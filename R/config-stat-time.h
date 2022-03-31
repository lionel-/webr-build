// stat-time configuration for Emscripten

/* Define to 1 if `st_atimensec' is a member of `struct stat'. */
#undef HAVE_STRUCT_STAT_ST_ATIMENSEC

/* Define to 1 if `st_atimespec.tv_nsec' is a member of `struct stat'. */
#undef HAVE_STRUCT_STAT_ST_ATIMESPEC_TV_NSEC

/* Define to 1 if `st_atim.st__tim.tv_nsec' is a member of `struct stat'. */
#undef HAVE_STRUCT_STAT_ST_ATIM_ST__TIM_TV_NSEC

/* Define to 1 if `st_atim.tv_nsec' is a member of `struct stat'. */
#define HAVE_STRUCT_STAT_ST_ATIM_TV_NSEC 1
