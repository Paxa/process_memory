#include "ruby.h"
#include <sys/resource.h>
#include <stdio.h>

/*
Idea from http://nadeausoftware.com/articles/2012/07/c_c_tip_how_get_process_resident_set_size_physical_memory_use
*/

#if defined(__APPLE__) && defined(__MACH__)
  #include <mach/mach.h>
#elif defined(__linux__) || defined(__linux) || defined(linux) || defined(__gnu_linux__)
  #include <unistd.h>
#endif

static VALUE rb_get_process_rss() {
  // For OS X
  #if defined(__APPLE__) && defined(__MACH__)
    struct mach_task_basic_info info;
    mach_msg_type_number_t infoCount = MACH_TASK_BASIC_INFO_COUNT;
    if ( task_info( mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &infoCount ) != KERN_SUCCESS ) {
      return INT2NUM(0);    /* Can't access? */
    }
    return INT2NUM(info.resident_size);

  // For Linux
  #elif defined(__linux__) || defined(__linux) || defined(linux) || defined(__gnu_linux__)
    long long rss = 0;
    FILE* file = fopen("/proc/self/statm", "r");

    if (file == NULL) { /* Can't open? */
      return INT2NUM(0);
    }

    if (fscanf(file, "%*s%Ld", &rss) != 1) {
      fclose(file);
      return INT2NUM(0);    /* Can't read? */
    }

    fclose(file);
    return INT2NUM(rss * sysconf(_SC_PAGESIZE));

  // Unsupported platforms
  // Windows, AIX, BSD, Solaris, QNX ...
  #else
    return INT2NUM(0);
  #endif
}



static VALUE
rb_get_process_peak_rss()
{
  struct rusage r_usage;
  getrusage(RUSAGE_SELF, &r_usage);

  #if defined(__APPLE__) && defined(__MACH__)
    return INT2NUM(r_usage.ru_maxrss);
  #else
    return INT2NUM(r_usage.ru_maxrss * 1024LL);
  #endif
}



void Init_process_memory_ext()
{
  VALUE mProcessMemoryExt = rb_define_module("ProcessMemoryExt");
  rb_define_singleton_method(mProcessMemoryExt, "get_peak_rss", rb_get_process_peak_rss, 0);
  rb_define_singleton_method(mProcessMemoryExt, "get_current_rss", rb_get_process_rss, 0);
}