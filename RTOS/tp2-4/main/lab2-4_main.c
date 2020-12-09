/****************************************************************************
 * Copyright (C) 2020 by Fabrice Muller                                     *
 *                                                                          *
 * This file is useful for ESP32 Design course.                             *
 *                                                                          *
 ****************************************************************************/

/**
 * @file lab2-4_main.c
 * @author Fabrice Muller
 * @date 13 Oct. 2020
 * @brief File containing the lab2-4 of Part 3.
 *
 * @see https://github.com/fmuller-pns/esp32-vscode-project-template
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "esp_log.h"
#include "soc/rtc_wdt.h"
#include "driver/gpio.h"

#include "freertos/FreeRTOSConfig.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

#include "my_helper_fct.h"

static const char* TAG = "MsgQ";

// Push button for interrupt
static const gpio_num_t PIN_PUSH_BUTTON = 15;

/* Stack size for all tasks */
const uint32_t TASK_STACK_SIZE = 4096;

/* Constant parameters */
const uint32_t COUNTER_TASK_PRIORITY = 2;

const uint32_t MESS_QUEUE_MAX_LENGTH = 5;

/* Queue */
QueueHandle_t xMsgQueue;

void vCounterTask(void *pvParameters);
static void IRAM_ATTR Push_button_isr_handler(void *args) ;

void app_main(void) {

	/* Config GPIO */
	gpio_config_t config_in;
	config_in.intr_type = GPIO_INTR_NEGEDGE;
	config_in.mode = GPIO_MODE_INPUT;
	config_in.pull_down_en = false;
	config_in.pull_up_en = true;
	config_in.pin_bit_mask = (1ULL << PIN_PUSH_BUTTON);
	gpio_config(&config_in);

	/* Create Message Queue and Check if created */
	xMsgQueue = xQueueCreate(MESS_QUEUE_MAX_LENGTH, sizeof(uint32_t));

	/* Create vCounterTask task */
	vTaskSuspendAll();
	xTaskCreatePinnedToCore(vCounterTask,	"CounterTask", TASK_STACK_SIZE,	(void*)"CounterTask", COUNTER_TASK_PRIORITY, NULL, CORE_0);
	xTaskResumeAll();					

	/* Install ISR */
	gpio_install_isr_service(0);
	gpio_isr_handler_add(PIN_PUSH_BUTTON, Push_button_isr_handler, (void*)PIN_PUSH_BUTTON);

	/* to ensure its exit is clean */
	vTaskDelete(NULL);
}

void vCounterTask(void *pvParameters) {
	uint32_t isrCount;
	uint32_t msgInQueue;
	for (;; ) {

		/* Wait for message with 5 sec. otherwise DISPLAY a message to push it */
		if (xQueueReceive(xMsgQueue, &isrCount, pdMS_TO_TICKS (5000))) {
    		DISPLAY("Button pressed ! isrCount = %d", isrCount);		
			// Get the number of items in the queue
			msgInQueue = uxQueueMessagesWaiting(xMsgQueue);
			// DISPLAYI (Information display) number of items if greater than 1
			if (msgInQueue > 1) DISPLAYI(TAG, "number of items if greater than 1");
			// Waiting for push button signal is 1 again (test every 20 ms)
			while (gpio_get_level(PIN_PUSH_BUTTON) != 1) vTaskDelay(pdMS_TO_TICKS(20));
			// DISPLAY "Button released"
			DISPLAY("Button released !");
		}
		else {
			DISPLAYE(TAG, "Please push the f***ing button !");
		}
		
	}
}


static void IRAM_ATTR Push_button_isr_handler(void *args) {

	// Increment isrCount
	static uint32_t isrCount = 0;
	// Send message
	isrCount++;
    uint32_t result = xQueueSend(xMsgQueue, &isrCount, 0);
}

