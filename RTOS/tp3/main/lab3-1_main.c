/****************************************************************************
 * Copyright (C) 2020 by Fabrice Muller                                     *
 *                                                                          *
 * This file is useful for ESP32 Design course.                             *
 *                                                                          *
 ****************************************************************************/

/**
 * @file lab3-1_main.c
 * @author Fabrice Muller
 * @date 20 Oct. 2020
 * @brief File containing the lab3-1 of Part 3.
 *
 * @see https://github.com/fmuller-pns/esp32-vscode-project-template
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <string.h>
#include "esp_log.h"

/* FreeRTOS.org includes. */
#include "freertos/FreeRTOSConfig.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

#include "my_helper_fct.h"

static const char* TAG = "SEM";

/* Application constants */
#define STACK_SIZE     4096
#define TABLE_SIZE     400

/* Task Priority */
const uint32_t TIMER_TASK_PRIORITY = 5;
const uint32_t INC_TABLE_TASK_PRIORITY = 3;
const uint32_t DEC_TABLE_TASK_PRIORITY = 3;
const uint32_t INSPECTOR_TASK_PRIORITY = 4;

/* Communications */
SemaphoreHandle_t xSemIncTable;
SemaphoreHandle_t xSemDecTable;
SemaphoreHandle_t xSemMutex;

/* Tasks */
void vTaskTimer(void *pvParameters);
void vTaskIncTable(void *pvParameters);
void vTaskDecTable(void *pvParameters);
void vTaskInspector(void *pvParameters);

/* Datas */
int Table[TABLE_SIZE];

/* Main function */
void app_main(void) {

	/* Init Table */
	// memset(Table, 0, TABLE_SIZE*sizeof(int));
	for (int i = 0; i < TABLE_SIZE; ++i) Table[i] = i;
	int const constNumber = 5;

	/* Create semaphore */
	xSemIncTable = xSemaphoreCreateBinary();
	xSemDecTable = xSemaphoreCreateBinary();
	xSemMutex = xSemaphoreCreateMutex();
	/* Stop scheduler */
	vTaskSuspendAll();

	/* Create Tasks */
	xTaskCreatePinnedToCore(vTaskTimer,	"Timer", STACK_SIZE,	(void*)"Timer", TIMER_TASK_PRIORITY,	NULL,CORE_0);
	xTaskCreatePinnedToCore(vTaskIncTable,	"IncTable", STACK_SIZE,	(void*)&constNumber, INC_TABLE_TASK_PRIORITY,	NULL,CORE_0);
	xTaskCreatePinnedToCore(vTaskDecTable,	"DecTable", STACK_SIZE,	(void*)"DecTable", DEC_TABLE_TASK_PRIORITY,	NULL,CORE_0);
	xTaskCreatePinnedToCore(vTaskInspector,	"Inspector", STACK_SIZE,	(void*)"Inspector", INSPECTOR_TASK_PRIORITY,	NULL,CORE_1);

	/* Continue scheduler */
	xTaskResumeAll();

	/* to ensure its exit is clean */
	vTaskDelete(NULL);
}
/*-----------------------------------------------------------*/

void vTaskTimer(void *pvParameters) {
	TickType_t xLastWakeTime = xTaskGetTickCount();
	for(;;){
		vTaskDelayUntil (& xLastWakeTime , pdMS_TO_TICKS (250));
		//xSemaphoreTake(xSemClk, portMAX_DELAY);
		COMPUTE_IN_TIME_MS(20);
		xSemaphoreGive(xSemIncTable);
		xSemaphoreGive(xSemDecTable);
		//xSemaphoreGive(xSemInspector);
		DISPLAYI(TAG, "TIMER: give sem");
	}
}

void vTaskIncTable(void *pvParameters) {
	int constNumber = *(int*)pvParameters;
	int activationNumber = 0;
	for(;;){
		xSemaphoreTake(xSemIncTable, portMAX_DELAY);
		DISPLAY("INC: take sem");
		if (activationNumber == 0){
			xSemaphoreTake(xSemMutex, portMAX_DELAY);
			DISPLAY("INC: take mutex");
			for (int i = 0; i < TABLE_SIZE-1; ++i)
				Table[i]+=constNumber;
			DISPLAY("INC: give mutex");
			xSemaphoreGive(xSemMutex);
			COMPUTE_IN_TIME_MS(50);
			activationNumber = 4;
		} else {
			activationNumber -=1;
		}
		DISPLAY("INC: task finished");
	}
}

void vTaskDecTable(void *pvParameters) {
	for(;;){
		xSemaphoreTake(xSemDecTable, portMAX_DELAY);
		xSemaphoreTake(xSemMutex, portMAX_DELAY);
		DISPLAY("DEC: take sem and mutex");
		for (int i = 0; i < TABLE_SIZE-1; ++i)
			Table[i]-=1;
		DISPLAY("DEC: give mutex");
		xSemaphoreGive(xSemMutex);
		COMPUTE_IN_TIME_MS(50);
		DISPLAY("DEC: task finished");
	}
}

void vTaskInspector(void *pvParameters) {
	int reference;
	bool error;
	for(;;){
		error = false;
		xSemaphoreTake(xSemMutex, portMAX_DELAY);
		reference = Table[0];
		DISPLAYI(TAG, "INSPECTOR: start checking");
		for (int i = 0; i < TABLE_SIZE-1; ++i){
			ets_delay_us(100);
			if (Table[i] != reference+i) error = true;
		}
		DISPLAYI(TAG,"INSPECTOR: checking finished");
		xSemaphoreGive(xSemMutex);
		vTaskDelay(2);
		if (error) {
			DISPLAYE(TAG, "Consistancy error in Table");
			exit(1);
		}
		DISPLAYI(TAG, "INSPECTOR: data in Table valid");
	}
}