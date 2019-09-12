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


#define SlavePos  0, 2
#define SlaveId  0x00000002, 0x0d1c3052

/* Offsets for PDO entries */
static unsigned int off_start_calib_pdo;
static unsigned int off_disable_calib_pdo;
static unsigned int off_input_freeze_pdo;
static unsigned int off_sample_mode_pdo;
static unsigned int off_tare_pdo;

static unsigned int off_filter_freq_pdo;


static unsigned int off_overrange_pdo;
static unsigned int off_data_invalid_pdo;
static unsigned int off_error_pdo;
static unsigned int off_calib_inprogress_pdo;
static unsigned int off_steady_state_pdo;
static unsigned int off_sync_error_pdo;
static unsigned int off_txpdo_toggle_pdo;
static unsigned int off_value_pdo;

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


//};



// pdo mapping / sync

//const static ec_pdo_entry_reg_t domain_regs[] = {
//        {SlavePos, SlaveId, 0x6000, 0x02, 1, &off_overrange_pdo},
//        {SlavePos, SlaveId, 0x6000, 0x04, 3, &off_data_invalid_pdo},
//        {SlavePos, SlaveId, 0x6000, 0x07, 6, &off_error_pdo},
//        {SlavePos, SlaveId, 0x6000, 0x08, 7, &off_calib_inprogress_pdo},
//        {SlavePos, SlaveId, 0x6000, 0x09, 10, &off_steady_state_pdo},
//        {SlavePos, SlaveId, 0x6000, 0x0E, 15, &off_sync_error_pdo},
//        {SlavePos, SlaveId, 0x6000, 0x10, 17, &off_txpdo_toggle_pdo},
//
//        {SlavePos, SlaveId, 0x6000, 0x12, 0, &off_value_pdo},
//
//        {SlavePos, SlaveId, 0x7000, 0x01, 0, &off_start_calib_pdo},
//        {SlavePos, SlaveId, 0x7000, 0x02, 1, &off_disable_calib_pdo},
//        {SlavePos, SlaveId, 0x7000, 0x03, 2, &off_input_freeze_pdo},
//        {SlavePos, SlaveId, 0x7000, 0x04, 3, &off_sample_mode_pdo},
//        {SlavePos, SlaveId, 0x7000, 0x05, 4, &off_tare_pdo},
////        {SlavePos, SlaveId, 0x7000, 0x11, &off_filter_freq_pdo},
//
//
//        {}
//};
//const static ec_pdo_entry_reg_t domain_regs[] = {
//
//        {SlavePos, SlaveId, 0x7000, 0x01, &off_start_calib_pdo, NULL},
//        {SlavePos, SlaveId, 0x7000, 0x02, &off_disable_calib_pdo, NULL},
//        {SlavePos, SlaveId, 0x7000, 0x03, &off_input_freeze_pdo, NULL},
//        {SlavePos, SlaveId, 0x7000, 0x04, &off_sample_mode_pdo, NULL},
//        {SlavePos, SlaveId, 0x7000, 0x05, &off_tare_pdo, NULL},
////        {SlavePos, SlaveId, 0x7000, 0x11, &off_filter_freq_pdo},
//
//        {SlavePos, SlaveId, 0x6000, 0x02, &off_overrange_pdo, NULL},
//        {SlavePos, SlaveId, 0x6000, 0x04, &off_data_invalid_pdo, NULL},
//        {SlavePos, SlaveId, 0x6000, 0x07, &off_error_pdo, NULL},
//        {SlavePos, SlaveId, 0x6000, 0x08, &off_calib_inprogress_pdo, NULL},
//        {SlavePos, SlaveId, 0x6000, 0x09, &off_steady_state_pdo, NULL},
//        {SlavePos, SlaveId, 0x6000, 0x0E, &off_sync_error_pdo, NULL},
//        {SlavePos, SlaveId, 0x6000, 0x10, &off_txpdo_toggle_pdo, NULL},
//
//        {SlavePos, SlaveId, 0x6000, 0x12, &off_value_pdo, NULL},
//
//        {}

static ec_pdo_entry_info_t el3356_pdo_control[] = {
        //output
        {0x7000, 0x01,  1},   //start calibration                //0x1600
        {0x7000, 0x02,  1},   //disable calibration                //0x1600
        {0x7000, 0x03,  1},   //input freeze                //0x1600
        {0x7000, 0x04,  1},   //sample mode                //0x1600
        {0x7000, 0x05,  1},   //tara                //0x1600
        {0x0000, 0x0,  3},   //gap
        {0x0000, 0x0,  8}   //gap
};

static ec_pdo_entry_info_t el3356_pdo_filter[] = {
        //output
        {0x7000, 0x11,  16},   //filter                //0x1600
};

static ec_pdo_info_t el3356_pdos_out[] = {
        {0x1600, 7, el3356_pdo_control},
        {0x1601, 1, el3356_pdo_filter},
};

static ec_pdo_entry_info_t el3356_pdo_status[] = {
        //input
        {0x0000, 0x0,  1},   //gap
        {0x6000, 0x02,  1},   //overrange                    //0x1A00
         {0x0000, 0x0,  1},   //gap
        {0x6000, 0x04,  1},   //data validation              //0x1A00
         {0x0000, 0x0,  2},   //gap
        {0x6000, 0x07,  1},   //error                        //0x1A00
        {0x6000, 0x08,  1},   //calibration in progress      //0x1A00
        {0x6000, 0x09,  1},   //steady state                 //0x1A00
         {0x0000, 0x0,  4},   //gap
        {0x6000, 0xE,  1},   //sync error                   //0x1A00
         {0x0000, 0x0,  1},   //gap
        {0x6000, 0x10, 1},   //tx pdo toggle               //0x1A00
};

static ec_pdo_entry_info_t el3356_pdo_value[] = {
        {0x6000, 0x12,  32}   //float value                //0x1A02
};

static ec_pdo_info_t el3356_pdos_in[] = {
        {0x1A00, 12, el3356_pdo_status},
        {0x1A02, 1, el3356_pdo_value}
};

static ec_sync_info_t el3356_syncs[] = {
        {0, EC_DIR_OUTPUT, 0, NULL},
        {1, EC_DIR_INPUT, 0, NULL},
        {2, EC_DIR_OUTPUT, 2, el3356_pdos_out},
        {3, EC_DIR_INPUT, 2, el3356_pdos_in},
        {0xff}
};



/****************************************************************************/

void cyclic_task() {
    static unsigned int counter = 0;
    struct timespec wakeupTime, time;
    unsigned int steady;
    signed int value;
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

            value = EC_READ_S32(domain_pd + off_value_pdo);
            printf("value: %i\n", value);
            steady = EC_READ_BIT(domain_pd + off_steady_state_pdo, 0);
            printf("steady: %i\n", steady);
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


    printf("Configuring PDOs...\n");
    if (ecrt_slave_config_pdos(sc, EC_END, el3356_syncs)) {
        fprintf(stderr, "Failed to configure EL3356 PDOs.\n");
    }

    printf("Registering PDOs...\n");
//    if (ecrt_domain_reg_pdo_entry_list(domain, domain_regs)) {
//        fprintf(stderr, "PDO entry registration failed!\n");
//        return -1;
//    }

    static unsigned int bit;
    off_start_calib_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x7000, 0x01, domain, &bit);
    printf("bit: %i\n", bit);
    off_disable_calib_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x7000, 0x02, domain, &bit);
    printf("bit: %i\n", bit);
    off_input_freeze_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x7000, 0x03, domain, &bit);
    printf("bit: %i\n", bit);
    off_sample_mode_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x7000, 0x04, domain, &bit);
    printf("bit: %i\n", bit);
    off_tare_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x7000, 0x05, domain, &bit);
    printf("bit: %i\n", bit);

    off_filter_freq_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x7000, 0x11, domain, &bit);
    printf("bit: %i\n", bit);

    off_overrange_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x02, domain, &bit);
    printf("bit: %i\n", bit);
    off_data_invalid_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x04, domain, &bit);
    printf("bit: %i\n", bit);
    off_error_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x07, domain, &bit);
    printf("bit: %i\n", bit);
    off_calib_inprogress_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x08, domain, &bit);
    printf("bit: %i\n", bit);
    off_steady_state_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x09, domain, &bit);
    printf("off_steady_state_pdo bit: %i\n", bit);
    off_sync_error_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x0E, domain, &bit);
    printf("bit: %i\n", bit);
    off_txpdo_toggle_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x10, domain, &bit);
    printf("bit: %i\n", bit);

    off_value_pdo = ecrt_slave_config_reg_pdo_entry(sc, 0x6000, 0x12, domain, &bit);
    printf("bit: %i\n", bit);

    printf("Activating master...\n");
    if (ecrt_master_activate(master)) {
        fprintf(stderr, "Failed to start MASTER.\n");
        return -1;
    }

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