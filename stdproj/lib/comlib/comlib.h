// some standard libraries
#ifndef __COMLIB__
#define __COMLIB__

#include "pico/stdlib.h"
#include "pico/error.h"
#include "hardware/gpio.h"
#include "stdio.h"
#include "stdlib.h"
#include <string.h>

#include "config.h"
#include "logger.h"

#define PROJECT_NAME				"PolyTheremin"
#define PROJECT_VERSION 			"0.0.3"
#define PROJECT_VERSION_DESCRIBE	"Test on new PCB"

#define timeup(actual_time, last_time, timeout) ((actual_time - last_time) > timeout)


#endif // __COMLIB__