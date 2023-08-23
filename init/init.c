#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mount.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/sysmacros.h>
#include <sys/types.h>
#include <unistd.h>

struct Mount
{
    const char *source, *target, *type;
    unsigned long flags;
    const void *data;
};

struct Mkdir
{
    const char *path;
    mode_t mode;
};

struct Mknod
{
    const char *path;
    mode_t mode;
    int major, minor;
};

struct Symlink
{
    const char *linkpath, *target;
};

enum OpType
{
    OpMount,
    OpMkdir,
    OpMknod,
    OpSymlink,
};

struct InitOp
{
    enum OpType op;
    union
    {
        struct Mount mount;
        struct Mkdir mkdir;
        struct Mknod mknod;
        struct Symlink symlink;
    };
};

const struct InitOp ops[] = {
    // mount /proc (which should already exist)
    {OpMount, .mount = {"proc", "/proc", "proc", MS_NODEV | MS_NOSUID | MS_NOEXEC}},

    // add symlinks in /dev (which is already mounted)
    {OpSymlink, .symlink = {"/dev/fd", "/proc/self/fd"}},
    {OpSymlink, .symlink = {"/dev/stdin", "/proc/self/fd/0"}},
    {OpSymlink, .symlink = {"/dev/stdout", "/proc/self/fd/1"}},
    {OpSymlink, .symlink = {"/dev/stderr", "/proc/self/fd/2"}},
};

void warn(const char *msg)
{
    int error = errno;
    perror(msg);
    errno = error;
}

void warn2(const char *msg1, const char *msg2)
{
    int error = errno;
    fputs(msg1, stderr);
    fputs(": ", stderr);
    errno = error;
    warn(msg2);
}

_Noreturn void dien()
{
    exit(errno);
}

_Noreturn void die(const char *msg)
{
    warn(msg);
    dien();
}

_Noreturn void die2(const char *msg1, const char *msg2)
{
    warn2(msg1, msg2);
    dien();
}

void init_rlimit()
{
    // Set the hard limit for number of open fds much larger. The kernel sets
    // a limit of 4096 for historical reasons, and this limit is too low for
    // some software. According to the systemd developers, there is no downside
    // to a large hard limit in modern Linux kernels.
    //
    // Retain the small soft limit of 1024 for appcompat.
    struct rlimit rlim = {
        .rlim_cur = 1024,
        .rlim_max = 1024 * 1024,
    };
    if (setrlimit(RLIMIT_NOFILE, &rlim) < 0)
    {
        die("setrlimit(RLIMIT_NOFILE)");
    }
}

void init_dev()
{
    if (mount("dev", "/dev", "devtmpfs", MS_NOSUID | MS_NOEXEC, NULL) < 0)
    {
        warn2("mount", "/dev");
        // /dev will be already mounted if devtmpfs.mount = 1 on the kernel
        // command line or CONFIG_DEVTMPFS_MOUNT is set. Do not consider this
        // an error.
        if (errno != EBUSY)
        {
            dien();
        }
    }
}

void init_fs(const struct InitOp *ops, size_t count)
{
    for (size_t i = 0; i < count; i++)
    {
        switch (ops[i].op)
        {
        case OpMount:
        {
            const struct Mount *m = &ops[i].mount;
            if (mount(m->source, m->target, m->type, m->flags, m->data) < 0)
            {
                die2("mount", m->target);
            }
            break;
        }
        case OpMkdir:
        {
            const struct Mkdir *m = &ops[i].mkdir;
            if (mkdir(m->path, m->mode) < 0)
            {
                warn2("mkdir", m->path);
                if (errno != EEXIST)
                {
                    dien();
                }
            }
            break;
        }
        case OpMknod:
        {
            const struct Mknod *n = &ops[i].mknod;
            if (mknod(n->path, n->mode, makedev(n->major, n->minor)) < 0)
            {
                warn2("mknod", n->path);
                if (errno != EEXIST)
                {
                    dien();
                }
            }
            break;
        }
        case OpSymlink:
        {
            const struct Symlink *sl = &ops[i].symlink;
            if (symlink(sl->target, sl->linkpath) < 0)
            {
                warn2("symlink", sl->linkpath);
                if (errno != EEXIST)
                {
                    dien();
                }
            }
            break;
        }
        }
    }
}

int main(int argc, char **argv)
{
    init_rlimit();
    init_dev();
    init_fs(ops, sizeof(ops) / sizeof(ops[0]));
    return 0;
}
