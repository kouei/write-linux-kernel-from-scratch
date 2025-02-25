#define __LIBRARY__
#include <unistd.h>
#include <stdarg.h>

_syscall3(int,read,int,fd,const char *,buf,off_t,count)
_syscall3(int,write,int,fd,const char *,buf,off_t,count)
_syscall3(int, ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg);
_syscall2(int, fstat,int, fildes, struct stat *, stat_buf)
_syscall2(int, mkdir, const char *, pathname, mode_t, mode)
_syscall1(int, rmdir, const char *, pathname)

static char printbuf[1024];
extern int vsprintf(char* buf, const char* fmt, va_list args);

int printf(const char* fmt, ...) {
    va_list args;
    int i;

    va_start(args, fmt);
    write(1, printbuf, i = vsprintf(printbuf, fmt, args));
    va_end(args);

    return i;
}

