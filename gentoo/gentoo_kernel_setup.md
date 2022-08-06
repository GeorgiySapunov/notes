---

Modern processors, like Intel Core or AMD Ryzen, support AES-NI instruction
set. AES-NI significantly improves encryption/decryption performance. To enable
AES-NI support in the kernel:

    KERNEL AES-NI cipher algorithm

    --- Cryptographic API
       <*>   AES cipher algorithms (AES-NI)

---
---

?
Optionally:

    KERNEL SHA-256 with NI instructions

    --- Cryptographic API
       <*>   SHA1 digest algorithm (SSSE3/AVX/AVX2/SHA-NI)
    │ │
       <*>   SHA256 digest algorithm (SSSE3/AVX/AVX2/SHA-NI)

---

# Mental outlaw setup:

---

Less kernel compression with ZSTD:

    General setup --->
        Kernel compression mode --->
            (X) ZSTD

---
---

Turn off POSIX Message Queues if you not going to run programs written for
Solaris that use it:

    General setup --->
        [ ] POSIX Message Queues

---
---

Potentially turn off but research this one:

    General setup --->
        [ ] Enable process_vm_readv/writev syscalls
        [ ] uselib syscall

---
---

    General setup --->
        [ ] Auditing support

---
---

?
Better performance but no sleep mode and more power consomption:

    General setup --->
        Timers sybsystem --->
            Timer tick handling (Idle dynticks system (tickless idle)) --->
                (X) Periodic timer ticks (constant rate, no dynticks)
            [ ] Old Idle dynticks config
            [ ] High Resolution Timer Support

For better battery life:

    General setup --->
        Timers sybsystem --->
            Timer tick handling (Idle dynticks system (tickless idle)) --->
                (X) Full dynticks system (tickless)

---
---

Could create some harmless errors in htop:

    General setup --->
        CPU/Task time and stats accounting --->
            [ ] BSD Process Accounting
            [ ] Export task/process statistics through netlink

---
---

Set log buffer sizes:

    General setup --->
        (15) Kernel log buffer size (16 => 64KB, 17 => 128KB)
        (15) CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)
        (12) Temporary per-CPU printk log buffer size (12 => 4KB, 13 => 8KB)

---
---

Turn initramfs off if you going to build drivers directly to the kernel.
Keep it turned on if you need to add modules to the kernel (e.g. Nvidia)

    General setup --->
        [ ] Initial RAM filesystem and RAM disk (initramfs/initrd) support

If you keep it turned on you can turn off support for unrelevant types of
compression.

    General setup --->
        [X] Initial RAM filesystem and RAM disk (initramfs/initrd) support
        [ ] Support initial ramdisk/ramfs compressed using gzip
        [ ] Support initial ramdisk/ramfs compressed using bzip2
        [ ] Support initial ramdisk/ramfs compressed using LZMA
        [ ] Support initial ramdisk/ramfs compressed using XZ
        [ ] Support initial ramdisk/ramfs compressed using LZ0
        [ ] Support initial ramdisk/ramfs compressed using LZ4
        [X] Support initial ramdisk/ramfs compressed using ZSTD

---
---

research

Don't need it in x64 system:

    Processor type and features --->
        [ ] Enable MPS table

---
---

research

    Processor type and features --->
        [ ] Support for extended (non-PC) x86 platforms

---
---

For intel i3, i7, i9:

    Processor type and features --->
        Processor family --->
            (X) Core 2/newer Xeon
For AMD:

    Processor type and features --->
        Processor family --->
            (X) Opteron/Athlon64/Hammer/K8

---
---

Set maximum number of CPUs to number of CPU threads:

    Processor type and features --->
        (number_of_threads) Maximum number of CPUs

---
---

?
Consider

    Processor type and features --->
        [ ] Multi-core scheduler support

---
---

Left it turn on for old CPUs (before sandy-bridge)

    Processor type and features --->
        [ ] Reroute for broken boot IRQs

---
---

Choose for your Processor:

    Processor type and features --->
        [*] Intel MCE features
        [ ] AMD MCE features
        Performance monitoring --->
            <*> Intel uncore performance events
            <*> Intel/AMD rapl performance events
            <*> Intel cstate performance events
            < > AMD Processor Power Reporting Mechanism
            < > AMD Uncore performance events
        [*] CPU microcode loading support
        [*]   Intel microcode loading support
        [ ]   AMD microcode loading support

---
---

This features necessary for legacy applications:

    Processor type and features --->
        [ ] IOPERM and IOPL Emulation

---
---

Leave it for future computers:

    Processor type and features --->
        [ ] Enable 5-level page tables support

---
---

?

Don't need it if you have less then 16 threads:

Or you do need it.

    Processor type and features --->
        [X] NUMA Memory Allocation and Scheduler Support

---
---

? research it!

    Processor type and features --->
        [*] Check for low memory corruption

---
---

    Processor type and features --->
        [*] MTRR cleanup support
        (1) MTRR cleanup enable value (0-1)
        (1) MTRR cleanup spare reg num (0-7)

---
---

This makes system more secure but affects performance:

    Processor type and features --->
        [*] Memory Protection Keys

---
---

Can be disabled as long as you're not going to be downloading different
kernels. Keep it on if you going to switch kernels frequently. Also allow
booting from recovery kernel:

    Processor type and features --->
        [ ] kexec system call
        [ ] kernel crash dumps
        [ ] Randomize the address of the  kernel image

You probably need it for Nvidia drivers:

    Processor type and features --->
        [X] kexec system call
        [X] kernel crash dumps
        [X] Randomize the address of the  kernel image

---
---

    Power management and ACPI options --->
        [ ] Power Management Debug Support

---
---

?

Consider this for laptops:

    Power management and ACPI options --->
        CPU frequency scaling --->
            <M> 'powersave' governor

---
---

For intel:

    Power management and ACPI options --->
        [*] Cpuidle Driver for Intel Processors

---
---

?

research it

    Enable loadable module support --->
        [ ] Forced module unloading

---
---

    Enable the block layer --->
        [ ] Block layer debugging information in debugfs

---
---

    Device Drivers --->
        < > PCCard (PCMCIA/CardBus) support

---
---

    Device Drivers --->
        Block devices --->
            (0) Number of loop devices to pre-create at init time

---
---

Consider to change NVME Support

    Device Drivers --->
        NVME Support --->

---
---

Could speed up boot time:

    Device Drivers --->
        SCSI device support --->
            [*] Asynchronous SCSI scanning

---
---

?

Consider

    Device Drivers --->
        [ ] Multiple devices driver support (RAID and LVM)

---
---

Mac drivers

    Device Drivers --->
        [ ] Macintosh device drivers

---
---

Consider

    Device Drivers --->
        Network device support --->
            < > Network console logging support

---
---

Turn off PS/2 support:

    Device Drivers --->
        Input device support --->
            Mice --->
                < > PS/2 mouse

---
---

Consider to turn it on since some sound cards needs it:

    Device Drivers --->
        <*> Multimedia support

---
---

Consider

    Device Drivers --->
        Input device support --->
            [ ] Joystics/Gamepads
            [ ] Tablets
            [ ] Touchscreens

---
---

Set appropriate configs:

    Device Drivers --->
        Graphics support --->
           (2) Maximum number of GPUs

?
Consider this one but probably keep it turned off:

    Device Drivers --->
        Graphics support --->
            [X] Laptop Hybrid Graphics - GPU switch support

Consider:

    Device Drivers --->
        Graphics support --->
            <*> AMD GPU
            <*> Nouveau (NVIDIA) cards
            <*> Intel 8xx/9xx/G3x/G4x/HD Graphics
            <*> Virtual box Graphics Card

---
---

    File systems --->
        [ ] Miscellaneous filesystems

---
---

Consider for ThinkPad

    Device Drivers --->
        X86 platform Specific Device Drivers --->
            <*> ThinkPad ACPI Laptop Extras

---
---

Consider if you don't have NAS drive:

    File systems --->
        [ ] Network File Systems

---
---

Consider NTFS and exFAT filesystems

    File systems --->
        DOS/FAT/EXFAT/NT Filesystems
        <X> exFAT filesystem support
        <X> NTFS Read-Write file system support

---
---

?
Research this one:

    Kernel hacking --->
        RCU Debugging --->
            (3) RCU CPU stall timeout in seconds

---
