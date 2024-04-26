
#include "logger.h"

#if SPIN_LOCK_ENABLE
	static int _logger_sync_num;
	static spin_lock_t *_logger_sync_count;
#endif

void logger_init(){

	#if SPIN_LOCK_ENABLE
		_logger_sync_num = spin_lock_claim_unused(true) ;
		_logger_sync_count = spin_lock_init(_logger_sync_num) ;
	#endif
}

void logger_test_colors(){

	logg(LOGGER, "TEST COLORS!\n");
	logc(LOGGER, COLOR_BLACK, 			"COLOR_BLACK\n");
	logc(LOGGER, COLOR_RED, 			"COLOR_RED\n");
	logc(LOGGER, COLOR_GREEN, 			"COLOR_GREEN\n");
	logc(LOGGER, COLOR_ORANGE, 			"COLOR_ORANGE\n");
	logc(LOGGER, COLOR_BLUE, 			"COLOR_BLUE\n");
	logc(LOGGER, COLOR_PURPLE, 			"COLOR_PURPLE\n");
	logc(LOGGER, COLOR_CYAN, 			"COLOR_CYAN\n");
	logc(LOGGER, COLOR_LIGHT_GRAY, 		"COLOR_LIGHT_GRAY\n");
	logc(LOGGER, COLOR_DARK_GRAY, 		"COLOR_DARK_GRAY\n");
	logc(LOGGER, COLOR_LIGHT_RED, 		"COLOR_LIGHT_RED\n");
	logc(LOGGER, COLOR_LIGHT_GREEN, 	"COLOR_LIGHT_GREEN\n");
	logc(LOGGER, COLOR_YELLOW, 			"COLOR_YELLOW\n");
	logc(LOGGER, COLOR_LIGHT_BLUE, 		"COLOR_LIGHT_BLUE\n");
	logc(LOGGER, COLOR_LIGHT_PURPLE,	"COLOR_LIGHT_PURPLE\n");
	logc(LOGGER, COLOR_LIGHT_CYAN, 		"COLOR_LIGHT_CYAN\n");
	logc(LOGGER, COLOR_WHITE, 			"COLOR_WHITE\n");

}

void logger_enable(debug_type_e type, bool enable){
	_debug_prefixes[type].enable = enable;
}


void logger_deinit(){
	#if SPIN_LOCK_ENABLE
		spin_lock_unclaim(_logger_sync_num);
	#endif
}




// #if SPIN_LOCK_ENABLE

void _logger_begin_block(){
	#if SPIN_LOCK_ENABLE
		spin_lock_unsafe_blocking(_logger_sync_count);
	#endif
}

void _logger_end_block(){
	#if SPIN_LOCK_ENABLE
		spin_unlock_unsafe(_logger_sync_count);
	#endif
}

// #endif










