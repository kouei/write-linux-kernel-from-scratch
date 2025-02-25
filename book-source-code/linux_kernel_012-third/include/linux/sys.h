extern int sys_setup();
extern int sys_exit();
extern int sys_fork();
extern int sys_read();
extern int sys_write();
extern int sys_open();
extern int sys_close();
extern int sys_waitpid();
//extern int sys_creat();
extern int sys_link();
extern int sys_unlink();
extern int sys_execve();
extern int sys_chdir();
extern int sys_time();
//extern int sys_mknod();
//extern int sys_chmod();
//extern int sys_chown();
//extern int sys_break();
extern int sys_stat();
//extern int sys_lseek();
extern int sys_getpid();
//extern int sys_mount();
//extern int sys_umount();
extern int sys_setuid();
extern int sys_getuid();
//extern int sys_stime();
//extern int sys_ptrace();
extern int sys_alarm();
extern int sys_fstat();
//extern int sys_pause();
extern int sys_utime();
//extern int sys_stty();
//extern int sys_gtty();
//extern int sys_access();
//extern int sys_nice();
//extern int sys_ftime();
extern int sys_sync();
extern int sys_kill();
//extern int sys_rename();
extern int sys_mkdir();
extern int sys_rmdir();
extern int sys_dup();
extern int sys_pipe();
//extern int sys_times();
//extern int sys_prof();
//extern int sys_brk();
//extern int sys_setgid();
//extern int sys_getgid();
extern int sys_signal();
extern int sys_geteuid();
extern int sys_getegid();
//extern int sys_acct();
//extern int sys_phys();
//extern int sys_lock();
extern int sys_ioctl();
extern int sys_fcntl();
//extern int sys_mpx();
//extern int sys_setpgid();
//extern int sys_ulimit();
//extern int sys_uname();
//extern int sys_umask();
//extern int sys_chroot();
//extern int sys_ustat();
//extern int sys_dup2();
extern int sys_getppid();
//extern int sys_getpgrp();
//extern int sys_setsid();
extern int sys_sigaction();
//extern int sys_sgetmask();
//extern int sys_ssetmask();
//extern int sys_setreuid();
//extern int sys_setregid();
//extern int sys_sigpending();
//extern int sys_sigsuspend();
//extern int sys_sethostname();
//extern int sys_setrlimit();
//extern int sys_getrlimit();
//extern int sys_getrusage();
//extern int sys_gettimeofday();
//extern int sys_settimeofday();
//extern int sys_getgroups();
//extern int sys_setgroups();
//extern int sys_select();
extern int sys_symlink();
//extern int sys_lstat();
//extern int sys_readlink();
//extern int sys_uselib();
extern int sys_ls();

fn_ptr sys_call_table[] = { 
    sys_setup,
    sys_exit,
    sys_fork,
    sys_read,
    sys_write,
    sys_open,
    sys_close,
    sys_waitpid,
    0,//    sys_creat,
    sys_link,

    sys_unlink,
    sys_execve,
    sys_chdir,
    sys_time,
    0,//    sys_mknod,
    0,//    sys_chmod,

    0,//    sys_chown,
    0,//    sys_break,
    sys_stat,
    0,//    sys_lseek,
    sys_getpid,
    0,//    sys_mount,

    0, //    sys_umount,
    sys_setuid,
    sys_getuid,
    0, //    sys_stime,
    0, //    sys_ptrace,
    sys_alarm,

    sys_fstat,
    0, //sys_pause,
    sys_utime,
    0,//    sys_stty,
    0,//    sys_gtty,
    0,//    sys_access,

    0,//    sys_nice,
    0,//    sys_ftime,
    sys_sync,
    sys_kill,
    0,//    sys_rename,
    sys_mkdir,

    sys_rmdir,
    sys_dup,
    sys_pipe,
    0,//    sys_times,
    0,//    sys_prof,
    0,//    sys_brk,
    0,//    sys_setgid,

    0,//    sys_getgid,
    sys_signal,
    sys_geteuid,
    sys_getegid,
    0,//    sys_acct,
    0,//    sys_phys,

    0, //    sys_lock,
    sys_ioctl,
    sys_fcntl,
    0, //    sys_mpx,
    0, //    sys_setpgid,
    0, //    sys_ulimit,

    0, //    sys_uname,
    0, //    sys_umask,
    0, //    sys_chroot,
    0, //    sys_ustat,
    0, //    sys_dup2,
    sys_getppid,

    0, //    sys_getpgrp,
    0, //    sys_setsid,
    sys_sigaction,
    0, //    sys_sgetmask,
    0, //    sys_ssetmask,

    0, //    sys_setreuid,
    0, //    sys_setregid,
    0, //    sys_sigsuspend,
    0, //    sys_sigpending,
    0, //    sys_sethostname,
    0, //    sys_setrlimit,
    0, //    sys_getrlimit,
    0, //    sys_getrusage,
    0, //    sys_gettimeofday,
    0, //    sys_settimeofday,
    0, //    sys_getgroups,
    0, //    sys_setgroups,
    0, //    sys_select,
    sys_symlink,
    0, //    sys_lstat,
    0, //    sys_readlink,
    0, //    sys_uselib
    sys_ls,
};

int NR_syscalls = sizeof(sys_call_table)/sizeof(fn_ptr);

