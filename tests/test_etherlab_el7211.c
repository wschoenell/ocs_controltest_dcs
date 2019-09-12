//
// Created by William Schoenell on 2019-05-13.
//

/*****************************************************************************
 * Mini example of PDO mapping with drive AKD Kollmorgen
 * The program maps some PDOs to monitor actual values of the drive
 *
 * Date: 2012-04-12 , Author: Sebastien BLANCHET
 *
 * Based on a previous example from IgH EtherCAT Master
 * http://lists.etherlab.org/pipermail/etherlab-users/attachments/20120413/b83b76d4/attachment.c
 ****************************************************************************/

#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>
#include "ecrt.h"
#include <sched.h> /* sched_setscheduler() */


/****************************************************************************/

// Application parameters
#define FREQUENCY 1000
#define CLOCK_TO_USE CLOCK_MONOTONIC

/****************************************************************************/

#define NSEC_PER_SEC (1000000000L)
#define PERIOD_NS (NSEC_PER_SEC / FREQUENCY)

#define DIFF_NS(A, B) (((B).tv_sec - (A).tv_sec) * NSEC_PER_SEC + \
    (B).tv_nsec - (A).tv_nsec)

#define TIMESPEC2NS(T) ((uint64_t) (T).tv_sec * NSEC_PER_SEC + (T).tv_nsec)

/****************************************************************************/


/* EtherCAT */
static ec_master_t *master = NULL;
static ec_domain_t *domain = NULL;
static uint8_t *domain_pd = NULL; /* process data */

static ec_slave_config_t *sc = NULL;


#define SlavePos  0, 1
#define SlaveId  0x00000002, 0x1C2B3052

/* Offsets for PDO entries */
static unsigned int off_pos_fb_pdo;
static unsigned int off_status_pdo;
static unsigned int off_vel_fb_pdo;
static unsigned int off_ctrl_pdo;
static unsigned int off_vel_cmd_pdo;

static unsigned int sync_ref_counter = 0;
const struct timespec cycletime = {0,
                                   PERIOD_NS};

/*****************************************************************************/

struct timespec timespec_add(struct timespec time1, struct timespec time2) {
    struct timespec result;

    if ((time1.tv_nsec + time2.tv_nsec) >= NSEC_PER_SEC) {
        result.tv_sec = time1.tv_sec + time2.tv_sec + 1;
        result.tv_nsec = time1.tv_nsec + time2.tv_nsec - NSEC_PER_SEC;
    } else {
        result.tv_sec = time1.tv_sec + time2.tv_sec;
        result.tv_nsec = time1.tv_nsec + time2.tv_nsec;
    }

    return result;
}

/*****************************************************************************/


const static ec_pdo_entry_reg_t domain_regs[] = {
        {SlavePos, SlaveId, 0x6000, 0x11, &off_pos_fb_pdo},
        {SlavePos, SlaveId, 0x6010, 0x01, &off_status_pdo},
        {SlavePos, SlaveId, 0x6010, 0x07, &off_vel_fb_pdo},
        {SlavePos, SlaveId, 0x7010, 0x01, &off_ctrl_pdo},
        {SlavePos, SlaveId, 0x7010, 0x06, &off_vel_cmd_pdo},
        {}
};

// pdo mapping / sync

static ec_pdo_entry_info_t el7211_in_pos[] = {
        {0x6000, 0x11, 32}  // actual position
};

static ec_pdo_entry_info_t el7211_in_status[] = {
        {0x6010, 0x01, 16}  // status word
};

static ec_pdo_entry_info_t el7211_in_vel[] = {
        {0x6010, 0x07, 32}  // actual velocity
};

static ec_pdo_entry_info_t el7211_out_ctrl[] = {
        {0x7010, 0x01, 16}  // control word
};

static ec_pdo_entry_info_t el7211_out_cmd[] = {
        {0x7010, 0x06, 32}  // velocity command
};

static ec_pdo_info_t el7211_pdos_in[] = {
        {0x1A00, 1, el7211_in_pos},
        {0x1A01, 1, el7211_in_status},
        {0x1A02, 1, el7211_in_vel},
};

static ec_pdo_info_t el7211_pdos_out[] = {
        {0x1600, 1, el7211_out_ctrl},
        {0x1601, 1, el7211_out_cmd},
};

static ec_sync_info_t el7211_syncs[] = {
        {0, EC_DIR_OUTPUT, 0, NULL},
        {1, EC_DIR_INPUT,  0, NULL},
        {2, EC_DIR_OUTPUT, 2, el7211_pdos_out},
        {3, EC_DIR_INPUT,  3, el7211_pdos_in},
        {0xff}
};


/****************************************************************************/

void cyclic_task() {
    static unsigned int counter = 0;
    struct timespec wakeupTime, time;
    unsigned int statusword;
    unsigned int control;
    int i_step = 0;

    clock_gettime(CLOCK_TO_USE, &wakeupTime);

    while (1) {

        wakeupTime = timespec_add(wakeupTime, cycletime);
        clock_nanosleep(CLOCK_TO_USE, TIMER_ABSTIME, &wakeupTime, NULL);

        /* receive process data */
        ecrt_master_receive(master);
        ecrt_domain_process(domain);

        if (counter) {
            counter--;
        } else { /* do this at 1 Hz */
            counter = FREQUENCY;
            /* read process data */

            statusword = EC_READ_U16(domain_pd + off_status_pdo);
            // State Machine implementation (Fig 127 of EL7211 manual)
            // Adapted from https://github.com/sittner/linuxcnc-ethercat/blob/eaff89f7c9d3b7efad7b7f85eaa9d66308641dbd/src/lcec_el7211.c
            if ((statusword >> 3) & 0x01) { // status: fault
                control = 0x80;
                printf("Status: fault\n");
            } else if ((statusword >> 6) & 0x01) { // status: disabled
                control = 0x06;
                printf("Status: switch on disabled\n");
            } else if (((statusword >> 0) & 0x01) &&
                       !((statusword >> 1) & 0x01)) { // status: ready and no switched on
                control = 0x07;
                printf("Status: ready to switch on\n");
            } else if ((statusword >> 1) & 0x01) { // status: switched on
                if (control != 0xf) {
                    printf("Status: Switched on\n");
                }
                control = 0xf;
            }

            EC_WRITE_U16(domain_pd + off_ctrl_pdo, control);

            if (control == 0xf) {

                printf("act_velocity = %d, act_pos = %d\n",
                       EC_READ_U32(domain_pd + off_vel_fb_pdo),
                       EC_READ_U32(domain_pd + off_pos_fb_pdo)
                );

                if (i_step < 60) {
                    i_step++;
                    EC_WRITE_U16(domain_pd + off_vel_cmd_pdo, 26214); // 10 percent of max velocity
                } else {
                    EC_WRITE_U16(domain_pd + off_vel_cmd_pdo, 0);
                }


            }
        }

        // write application time to master
        clock_gettime(CLOCK_TO_USE, &time);
        ecrt_master_application_time(master, TIMESPEC2NS(time));

        if (sync_ref_counter) {
            sync_ref_counter--;
        } else {
            sync_ref_counter = 1; // sync every cycle
            ecrt_master_sync_reference_clock(master);
        }
        ecrt_master_sync_slave_clocks(master);


        /* send process data */
        ecrt_domain_queue(domain);
        ecrt_master_send(master);
    }
}

/****************************************************************************/

int main(int argc, char **argv) {
    master = ecrt_request_master(0);
    if (!master)
        return -1;

    domain = ecrt_master_create_domain(master);
    if (!domain)
        return -1;

    if (!(sc = ecrt_master_slave_config(master, SlavePos, SlaveId))) {
        fprintf(stderr, "Failed to get slave configuration.\n");
        return -1;
    }

    // Config DC
    ecrt_slave_config_dc(sc, 0x0700, PERIOD_NS, 4400000, 0, 0);


    printf("Configuring PDOs...\n");
    if (ecrt_slave_config_pdos(sc, EC_END, el7211_syncs)) {
        fprintf(stderr, "Failed to configure EL7211 PDOs.\n");
    }

    if (ecrt_domain_reg_pdo_entry_list(domain, domain_regs)) {
        fprintf(stderr, "PDO entry registration failed!\n");
        return -1;
    }

    printf("Activating master...\n");
    if (ecrt_master_activate(master))
        return -1;

    if (!(domain_pd = ecrt_domain_data(domain))) {
        return -1;
    }


    /* Set priority */

    struct sched_param param = {};
    param.sched_priority = sched_get_priority_max(SCHED_FIFO);

    printf("Using priority %i.", param.sched_priority);
    if (sched_setscheduler(0, SCHED_FIFO, &param) == -1) {
        perror("sched_setscheduler failed");
    }

    // Start
    printf("Started.\n");
    cyclic_task();

    return 0;
}

/****************************************************************************/