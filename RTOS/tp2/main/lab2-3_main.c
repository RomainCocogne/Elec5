/****************************************************************************
 * Copyright (C) 2020 by Fabrice Muller                                     *
 *                                                                          *
 * This file is useful for ESP32 Design course.                             *
 *                                                                          *
 ****************************************************************************/

/**
 * @file lab2-3_main.c
 * @author Fabrice Muller
 * @date 13 Oct. 2020
 * @brief File containing the lab2-3 of Part 3.
 *
 * @see https://github.com/fmuller-pns/esp32-vscode-project-template
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "esp_log.h"

/* FreeRTOS.org includes. */
#include "freertos/FreeRTOSConfig.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

#include "my_helper_fct.h"



static const char* TAG = "MsgQ";

/* Stack size for all tasks */
const uint32_t TASK_STACK_SIZE = 4000;

const char *pcSenderTaskNamePrefix = "SenderTask";
const char *pcReceiverTaskNamePrefix = "ReceiverTask";

/* Constant parameters */
const uint32_t SENDER_TASK_PRIORITY = 2;
const uint32_t RECEIVER_TASK_PRIORITY = 2;
const uint32_t FUNCTION_TASK_PRIORITY = 3;

const uint32_t MESS_QUEUE_MAX_LENGTH = 5;

const uint32_t SENDER_TASK_NUMBER = 1;
const uint32_t RECEIVER_TASK_NUMBER = 2;
const uint32_t FUNCTION_TASK_NUMBER = 3;

/* Sender task parameters */
uint32_t *pulSenderTaskParam;

/* Queue */
QueueHandle_t xMsgQueue;

/* The task functions. */
void vSenderTask(void *pvParameters);
void vReceiverTask(void *pvParameters);
void vTaskFunction(void *pvParameters);

void app_main(void) {


	/* Create Message Queue */
	xMsgQueue = xQueueCreate(MESS_QUEUE_MAX_LENGTH, sizeof(uint32_t));
	/* Stop Scheduler */
	vTaskSuspendAll();

	/* Create sender task. */
	xTaskCreatePinnedToCore(vSenderTask,	"Task 1", TASK_STACK_SIZE,	(void*)"Task 1", SENDER_TASK_PRIORITY,	NULL,CORE_0);

	/* Create receiver task. */
	xTaskCreatePinnedToCore(vReceiverTask,	"Task 2", TASK_STACK_SIZE,	(void*)"Task 2", RECEIVER_TASK_PRIORITY,	NULL,CORE_0);

	/* Create task 3. */
	xTaskCreatePinnedToCore(vTaskFunction,	"Task 3", TASK_STACK_SIZE,	(void*)"Task 3", FUNCTION_TASK_NUMBER,	NULL,CORE_0);

	/* Continue Scheduler */
	xTaskResumeAll();	

	/* to ensure its exit is clean */
	vTaskDelete(NULL);
}
/*-----------------------------------------------------------*/

void vSenderTask(void *pvParameters) {

	/* Get Task name */
	char *pcTaskName = (char *)pvParameters;
	int data = 50;

	TickType_t xLastWakeTime = xTaskGetTickCount();
	for (;; ) {
		// Simulate preparation of next message
		COMPUTE_IN_TICK(4);		
		
		// Send message without timeout
		DISPLAY("%s, WILL add message %d to MsgQ", pcTaskName, data);
    	uint32_t result = xQueueSend(xMsgQueue, &data, 0);
		if (result) {
			DISPLAY("%s, added message %d to MsgQ", pcTaskName, data);
		} 
		else {
			DISPLAYE(TAG, "%s, Failed to add message %d to MsgQ", pcTaskName, data);
		}
		// Period = 500 ms
		vTaskDelayUntil (& xLastWakeTime , pdMS_TO_TICKS (500));
	}
}

void vReceiverTask(void *pvParameters) {

	/* Get Task name */
	char *pcTaskName = (char *)pvParameters;

	uint32_t value;
	for (;; ) {

		// Wait for message with infinite timeout
    	if (xQueueReceive(xMsgQueue, &value, pdMS_TO_TICKS (300))) {
    		DISPLAY("%s, mess = %d", pcTaskName, value);
			// Simulate use of message
			COMPUTE_IN_TICK(3);
		}
		else {
			DISPLAYE(TAG, "%s, Timeout !", pcTaskName);
			COMPUTE_IN_TICK(1);
		}
	}
}

void vTaskFunction(void *pvParameters) {
	char *pcTaskName;
	volatile uint32_t ul;
	TickType_t xLastWakeTime;

	/* The string to print out is passed in via the parameter.  Cast this to a
	character pointer. */
	pcTaskName = (char *)pvParameters;

	DISPLAY("Start of %s task, priority = %d",pcTaskName, uxTaskPriorityGet(NULL));

	xLastWakeTime = xTaskGetTickCount();
	/* As per most tasks, this task is implemented in an infinite loop. */
	for (;; ) {
		vTaskDelay(pdMS_TO_TICKS(100));
		DISPLAY("Run computation of %s", pcTaskName);
		COMPUTE_IN_TICK(2);
		DISPLAY("End of %s", pcTaskName);
	}
}