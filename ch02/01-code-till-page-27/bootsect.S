SETUPLEN = 4

BOOTSEG  = 0x7c0

INITSEG  = 0x9000

SETUPSEG = ((INITSEG << 4) + SECTOR_SIZE_IN_BYTES) >> 4

SYSSEG   = 0x1000

ENDSEG   = SYSSEG + SYSSIZE

ROOT_DEV = 0x000

INTERRUPTION_TO_DISPLAY_CHARACTER = 0x10

INTERRUPTION_TO_LOAD_FLOPPY_DISK  = 0x13

SECTOR_SIZE_IN_BYTES = 512

SECTOR_SIZE_IN_WORD = SECTOR_SIZE_IN_BYTES / 2 # On x86 machine 1 word = 2 bytes

RED_COLOR = 0x0c

.code16
.text

.global _start
_start:
    jmpl $BOOTSEG, $start2 # Does two things, 1) set %cs = $BOOTSEG, 2) jump to $start2 label

start2:
    movw $BOOTSEG, %ax
    movw %ax, %ds
    movw $INITSEG, %ax
    movw %ax, %es
    movw $SECTOR_SIZE_IN_WORD, %cx
    subw %si, %si
    subw %di, %di

    rep                  # rep + movsw means: "Repeat copy a word (2 bytes) from address (%ds << 4) + %si to address (%es << 4) + %di, until %cx == 0"
    movsw

    jmpl $INITSEG, $go   # Does two things, 1) set %cs = $INITSEG, 2) jump to $go label

go:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0xFF00, %sp

load_setup:
    movw $0x0000, %dx    # %dh means the id of magnetic head, %dl means drive id, 0 means floppy disk, 7 means hard disk.
    movw $0x0002, %cx    # %ch means the lower 8 bits of cylinder id, the first 0~5 bits in %cl means start sector id, 6~7 bits means the higher 2 bits of magnetic track
    movw $SECTOR_SIZE_IN_BYTES, %bx    # (%es << 4) + %bx is the address of the buffer. If there is any error, the CF bit will be set
    movb $SETUPLEN, %al  # %al means the number of sectors to load
    movb $0x02, %ah      # %ah == 0x02 means: load sector (512 bytes) from disk to memory
    int $INTERRUPTION_TO_LOAD_FLOPPY_DISK
    jnc ok_load_setup    # If CF == 0, then jump to ok_load_setup; Otherwise if CF == 0, don't jump.
    movw $0x0000, %dx
    movw $0x0000, %ax    # %ah == 0x0 means reset disk
    int $INTERRUPTION_TO_LOAD_FLOPPY_DISK # When %ah == 0, this interruption will reset disk
    jmp load_setup       # load setup failed, jump to load_setup to retry

ok_load_setup:
    movw $msg, %ax
    movw %ax, %bp
    movb $0x13, %ah          # %ah = 0x13 means display character string in teletype mode 
    movb $0x01, %al          # %al = 0x01 means character string not only contains characters, but also properties of how should we display them  (e.g., color)
    movw $RED_COLOR, %bx # Set text color to red
    movw $MSGLEN, %cx
    movb $0, %dh             # %dh = row number from where to print characters
    movb $0, %dl             # %dl = col number from where to print characters
    int $INTERRUPTION_TO_DISPLAY_CHARACTER

    jmpl $SETUPSEG, $0   # Does two things, 1) set %cs = $SETUPSEG, 2) jump to $0

MSGLEN = 21              # $msg length = 21
msg:
.ascii "Setup has been loaded"

.org 508
root_dev:
    .word ROOT_DEV
boot_flag:
    .word 0xaa55
    