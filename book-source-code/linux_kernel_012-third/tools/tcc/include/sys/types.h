#ifndef _SYS_TYPES_H
#define _SYS_TYPES_H

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned int size_t;
#endif

#ifndef _TIME_T
#define _TIME_T
typedef long time_t;
#endif

#ifndef _PTRDIFF_T
#define _PTRDIFF_T
typedef long ptrdiff_t;
#endif

#ifndef NULL
#define NULL ((void *) 0)
#endif

typedef long off_t;

typedef int pid_t;
typedef unsigned short uid_t;
typedef unsigned short mode_t;
typedef unsigned short ino_t;
typedef unsigned short gid_t;
typedef unsigned short dev_t;
typedef unsigned short umode_t;
typedef unsigned char nlink_t;
typedef unsigned char cc_t;
typedef unsigned int speed_t;
typedef unsigned long tcflag_t;

#endif
