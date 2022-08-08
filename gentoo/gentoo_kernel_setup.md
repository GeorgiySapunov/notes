## General setup

    General setup --->
        # Less kernel compression with ZSTD:
        Kernel compression mode --->
            (X) ZSTD
        # If you not going to run programs written for Solaris that use it
        [ ] POSIX Message Queues
        # Potentially turn off but research this one:
        [ ] Enable process_vm_readv/writev syscalls
        [ ] uselib syscall
        #
        [ ] Auditing support
        Timers sybsystem --->
            # ? Better performance but no sleep mode and more power consomption:
            Timer tick handling (Idle dynticks system (tickless idle)) --->
                (X) Periodic timer ticks (constant rate, no dynticks)
            [ ] Old Idle dynticks config
            [ ] High Resolution Timer Support
            # For better battery life:
            Timer tick handling (Idle dynticks system (tickless idle)) --->
                (X) Full dynticks system (tickless)
        # Could create some harmless errors in htop:
        CPU/Task time and stats accounting --->
            [ ] BSD Process Accounting
            [ ] Export task/process statistics through netlink
        # Set log buffer sizes:
        (15) Kernel log buffer size (16 => 64KB, 17 => 128KB)
        (15) CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)
        (12) Temporary per-CPU printk log buffer size (12 => 4KB, 13 => 8KB)
        # Turn initramfs off if you going to build drivers directly to the kernel.
        # Keep it turned on if you need to add modules to the kernel (e.g. Nvidia)
        [ ] Initial RAM filesystem and RAM disk (initramfs/initrd) support
        # If you keep previous setting turned on you can turn off support for
        # unrelevant types of compression.
        [X] Initial RAM filesystem and RAM disk (initramfs/initrd) support
        [ ] Support initial ramdisk/ramfs compressed using gzip
        [ ] Support initial ramdisk/ramfs compressed using bzip2
        [ ] Support initial ramdisk/ramfs compressed using LZMA
        [ ] Support initial ramdisk/ramfs compressed using XZ
        [ ] Support initial ramdisk/ramfs compressed using LZ0
        [ ] Support initial ramdisk/ramfs compressed using LZ4
        [X] Support initial ramdisk/ramfs compressed using ZSTD

## Processor type and features

    Processor type and features --->
        # research
        # Don't need it in x64 system:
        [ ] Enable MPS table
        # research
        [ ] Support for extended (non-PC) x86 platforms
        #
        Processor family --->
            # For intel i3, i7, i9:
            (X) Core 2/newer Xeon
            # For AMD:
            (X) Opteron/Athlon64/Hammer/K8
        # Set maximum number of CPUs to number of CPU threads:
        (number_of_threads) Maximum number of CPUs
        # ? Consider
        [ ] Multi-core scheduler support
        # Left it turn on for old CPUs (before sandy-bridge)
        [ ] Reroute for broken boot IRQs
        # Choose for your Processor:
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
        # This features necessary for legacy applications:
        [ ] IOPERM and IOPL Emulation
        # Leave it for future computers:
        [ ] Enable 5-level page tables support
        # ? Don't need it if you have less then 16 threads:
        # Or you do need it.
        [X] NUMA Memory Allocation and Scheduler Support
        # ? research it!
        [*] Check for low memory corruption
        #
        [*] MTRR cleanup support
        (1) MTRR cleanup enable value (0-1)
        (1) MTRR cleanup spare reg num (0-7)
        # This makes system more secure but affects performance:
        [*] Memory Protection Keys
        # Can be disabled as long as you're not going to be downloading different
        # kernels. Keep it on if you going to switch kernels frequently. Also allow
        # booting from recovery kernel:
        [ ] kexec system call
        [ ] kernel crash dumps
        [ ] Randomize the address of the  kernel image
        # You probably need it for Nvidia drivers:
        [X] kexec system call
        [X] kernel crash dumps
        [X] Randomize the address of the  kernel image

## Power management and ACPI options

        Power management and ACPI options --->
            [ ] Power Management Debug Support
            # ? Consider this for laptops:
            CPU frequency scaling --->
                <M> 'powersave' governor
            # For intel:
            [*] Cpuidle Driver for Intel Processors

## Enable loadable module support

    Enable loadable module support --->
        # ? research it
        [ ] Forced module unloading

## Enable the block layer

    --- Enable the block layer --->
        [ ] Block layer debugging information in debugfs

## Device Drivers

    Device Drivers --->
        < > PCCard (PCMCIA/CardBus) support
        #
        Block devices --->
            (0) Number of loop devices to pre-create at init time
        # Consider to change NVME Support
        NVME Support --->
        # Could speed up boot time:
        SCSI device support --->
            [*] Asynchronous SCSI scanning
        # ? Consider
        [ ] Multiple devices driver support (RAID and LVM)
        # Mac drivers
        [ ] Macintosh device drivers
        # Consider
        Network device support --->
            < > Network console logging support
        Input device support --->
            # Turn off PS/2 support:
            Mice --->
                < > PS/2 mouse
            # Consider
            [ ] Joystics/Gamepads
            [ ] Tablets
            [ ] Touchscreens
        # Consider to turn it on since some sound cards needs it:
        <*> Multimedia support
        # Set appropriate configs:
        Graphics support --->
           (2) Maximum number of GPUs
        Graphics support --->
            # ? Consider this one but probably keep it turned off:
            [X] Laptop Hybrid Graphics - GPU switch support
            # Consider:
            <*> AMD GPU
            <*> Nouveau (NVIDIA) cards
            <*> Intel 8xx/9xx/G3x/G4x/HD Graphics
            <*> Virtual box Graphics Card
        # Consider for ThinkPad
        X86 platform Specific Device Drivers --->
            <*> ThinkPad ACPI Laptop Extras

## File systems

    File systems --->
        [ ] Miscellaneous filesystems
        # Consider if you don't have NAS drive:
        [ ] Network File Systems

## Cryptographic API

    --- Cryptographic API --->
        # Modern processors, like Intel Core or AMD Ryzen, support AES-NI
        # instruction set. AES-NI significantly improves encryption/decryption
        # performance. To enable AES-NI support in the kernel:
       <*>   AES cipher algorithms (AES-NI)

## Kernel hacking

    Kernel hacking --->
        # ? Research this one:
        RCU Debugging --->
            (3) RCU CPU stall timeout in seconds
