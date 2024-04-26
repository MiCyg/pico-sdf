// thread safe library for logging some stuff

#ifndef __LOGGER__
#define __LOGGER__

#include "comlib.h"
#include "colors.h"
#include "hardware/clocks.h"

// some configures
#define DEBUG_ENABLE			1
#define SPIN_LOCK_ENABLE		1


#define ERR_COLOR				COLOR_RED
#define WARN_COLOR				COLOR_YELLOW
#define DEBUG_COLOR				COLOR_BLUE


#if SPIN_LOCK_ENABLE
	#include "pico/sync.h"
#endif


// lib types to log
typedef enum debug_type_e{
	MAIN,
	LOGGER,

	DEB_TYPE_NUM,
} debug_type_e;

static struct type_char_t{
	debug_type_e type;	
	char * prefix;	
	bool enable;	
} _debug_prefixes[DEB_TYPE_NUM] = {
	{ .type=MAIN,		.prefix="MAIN",		.enable=true	},
	{ .type=LOGGER,	 	.prefix="LOGGER",	.enable=true	},
};

void logger_init();
void logger_deinit();
void logger_enable(debug_type_e type, bool enable);
void logger_test_colors();



#define LOG_TAB(tab)		for(uint8_t i=0;i<tab;i++)printf("-"); if(tab)printf(">")
#define LOG_CAT(cat)		printf("%s: ", cat)
#define LOG_COLOR(color)	printf("%s", color)
#define LOG_ENDCOLOR()	printf("%s", NOCOLOR)

void _logger_begin_block();
void _logger_end_block();

#if DEBUG_ENABLE
#define logg(type, ...) 								\
	do {											\
		_logger_begin_block();						\
		if(type < DEB_TYPE_NUM){					\
			if(_debug_prefixes[type].enable){		\
				LOG_TAB(type);							\
				LOG_CAT(_debug_prefixes[type].prefix);	\
				printf(__VA_ARGS__);					\
			}										\
		}											\
		_logger_end_block();						\
	} while(0)
#else
	#define logg(type, ...) do {} while(0)
#endif

#if DEBUG_ENABLE
#define logc(type, color, ...) 				\
	do {											\
		_logger_begin_block();						\
		if(type < DEB_TYPE_NUM){					\
			if(_debug_prefixes[type].enable){		\
				LOG_COLOR(color);						\
				LOG_TAB(type);							\
				LOG_CAT(_debug_prefixes[type].prefix);	\
				printf(__VA_ARGS__);					\
				LOG_ENDCOLOR();							\
			}										\
		}											\
		_logger_end_block();						\
	} while(0)
#else
	#define logc(type, ...) do {} while(0)
#endif

#if DEBUG_ENABLE
#define logi(type, ...)						\
	do {											\
		_logger_begin_block();						\
		if(type < DEB_TYPE_NUM){					\
			if(_debug_prefixes[type].enable){		\
				LOG_COLOR(COLOR_BLUE);					\
				LOG_TAB(type);							\
				LOG_CAT(_debug_prefixes[type].prefix);	\
				printf(__VA_ARGS__);					\
				LOG_ENDCOLOR();							\
			}										\
		}											\
		_logger_end_block();						\
	} while(0)
#else
	#define logi(type, ...) do {} while(0)
#endif

#if DEBUG_ENABLE
#define loge(type, ...)						\
	do {											\
		_logger_begin_block();						\
		if(type < DEB_TYPE_NUM){					\
			if(_debug_prefixes[type].enable){		\
				LOG_COLOR(COLOR_RED);					\
				LOG_TAB(type);							\
				LOG_CAT(_debug_prefixes[type].prefix);	\
				printf(__VA_ARGS__);					\
				LOG_ENDCOLOR();							\
			}										\
		}											\
		_logger_end_block();						\
	} while(0)
#else
	#define loge(type, ...) do {} while(0)
#endif

#if DEBUG_ENABLE
#define logw(type, ...)						\
	do {											\
		_logger_begin_block();						\
		if(type < DEB_TYPE_NUM){					\
			if(_debug_prefixes[type].enable){		\
				LOG_COLOR(COLOR_YELLOW);				\
				LOG_TAB(type);							\
				LOG_CAT(_debug_prefixes[type].prefix);	\
				printf(__VA_ARGS__);					\
				LOG_ENDCOLOR();							\
			}										\
		}											\
		_logger_end_block();						\
	} while(0)
#else
	#define logw(type, ...) do {} while(0)
#endif

#if DEBUG_ENABLE
#define log_hex(type, data, len) 					\
	do {											\
		_logger_begin_block();						\
		if(type < DEB_TYPE_NUM){					\
			if(_debug_prefixes[type].enable){		\
				LOG_CAT(_debug_prefixes[type].prefix);	\
				for (size_t i = 0; i < len; i++)		\
				{										\
					printf("%02X ", data[i]);			\
				}										\
			}										\
		}											\
		_logger_end_block();						\
	} while(0)
#else
	#define log_hex(type, ..., ...) do {} while(0)
#endif

#endif // __LOGGER__