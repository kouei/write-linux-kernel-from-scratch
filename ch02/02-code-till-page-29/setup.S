INITSEG  = 0x9000

GREEN_COLOR = 0x0a

INTERRUPTION_TO_DISPLAY_CHARACTER = 0x10

INTERRUPTION_TO_GET_EXTENDED_MEMORY_SIZE = 0x15

INTERRUPTION_TO_GET_DISK_INFO = 0x13

FIRST_DISK_INFO = 4 * 0x41

SECOND_DISK_INFO = 4 * 0x46

DISK_INFO_SIZE_IN_BYTES = 16

.code16
.text
.globl _start_setup

_start_setup:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es

    movw $setup_msg, %ax
    movw %ax, %bp
    movb $0x13, %ah          # %ah = 0x13 means display character string in teletype mode 
    movb $0x01, %al          # %al = 0x01 means character string not only contains characters, but also properties of how should we display them  (e.g., color)
    movw $GREEN_COLOR, %bx
    movw $SETUP_MSG_LEN, %cx
    movb $3, %dh             # %dh = row number from where to print characters
    movb $0, %dl             # %dl = col number from where to print characters
    int  $INTERRUPTION_TO_DISPLAY_CHARACTER



    # Below is the actual code to load hardware info from BIOS
    
    # Get cursor position
    movw $INITSEG, %ax
    movw %ax, %ds
    movb $0x03, %ah          # %ah = 0x03 means to capture current cursor position (using interruption 0x10), and put the result in %dx
    xor  %bh, %bh
    int  $INTERRUPTION_TO_DISPLAY_CHARACTER
    movw %dx, (0)            # Save %dx to memory address (%ds << 4) + 0, which is 0x90000
    
    
    # Get extended memory size
    movb $0x88, %ah          # %ah = 0x88 means to get extended memory size through interruption 0x15, and save the result in %ax
    int  $INTERRUPTION_TO_GET_EXTENDED_MEMORY_SIZE
    movw %ax, (2)            # Save %ax to memory address (%ds << 4) + 2, which is 0x90002


    # Get video monitor column numbers, display mode, page numbers
    movb $0x0f, %ah          # %ah = 0x0f means to get video monitor mode through interruption 0x10, and save result in %ax and %bx
                             # %ah means the number of columns the video monitor has
                             # %al means the display mode of the video monitor
                             # %bh means the number of pages the video monitor has
    int  $INTERRUPTION_TO_DISPLAY_CHARACTER
    movw %bx, (4)
    movw %ax, (6)

    movb $0x12, %ah          # %ah = 0x12 and %bl = 0x10 through interruption 0x10 means to get graphics card info and save the result in %ax, %bx and %cx
    movb $0x10, %bl
    int  $INTERRUPTION_TO_DISPLAY_CHARACTER
    movw %ax, (8)            # Return value in %ax has been deprecated, it's useless and we just store it here.
    movw %bx, (10)           # %bh means video mode, 0x00 means color mode, 0x01 means black and white mode.
                             # %bl means GPU memory, 0x00 means 64KB, 0x01 means 128KB, 0x02 means 192KB, 0x03 means 256KB
    movw %cx, (12)           # %ch and %cl contain other info, refer to book page 29

    # Get first disk info
    movw $0x0000, %ax
    movw %ax, %ds
    ldsw $FIRST_DISK_INFO, %si  # It's the same as "movw $FIRST_DISK_INFO, %si", ldsw makes it clear that what stores in %si should be an address
    movw $INITSEG, %ax
    movw %ax, %es
    movw $0x0080, %di
    movw $DISK_INFO_SIZE_IN_BYTES, %cx
    rep
    movsb                       # rep + movsb means: "Repeat copy 1 byte from address (%ds << 4) + %si to address (%es << 4) + %di, and decrease %cx by 1, until %cx == 0"

    # Get second disk info
    movw $0x0000, %ax
    movw %ax, %ds
    ldsw $SECOND_DISK_INFO, %si # It's the same as "movw $SECOND_DISK_INFO, %si", ldsw makes it clear that what stores in %si should be an address
    movw $INITSEG, %ax
    movw %ax, %es
    movw $0x0090, %di
    movw $DISK_INFO_SIZE_IN_BYTES, %cx
    rep
    movsb                       # rep + movsb means: "Repeat copy 1 byte from address (%ds << 4) + %si to address (%es << 4) + %di, and decrease %cx by 1, until %cx == 0"

    # Check whether second disk exists
    movw $0x1500, %ax           # %ah = 15 through interruption 0x15 means to get disk info, and save the result in %ah
                                # %ah = 0 means no disk found and CF bit is set. %ah = 1 or 2 menas this disk is a floppy disk. %ah = 3 means this disk is a hard disk.
    movb $0x81, %dl             # %dl = 0x80 means to get first disk info, %dl = 0x81 means to get second disk info
    int  $INTERRUPTION_TO_GET_DISK_INFO
    jc   no_disk1
    cmpb $3, %ah
    je   is_disk1

    # If there is no second disk (disk1), then clean up its info we get previously (set them to 0)
no_disk1:
    movw $INITSEG, %ax
    movw %ax, %es
    movw $0x0090, %di
    movw $DISK_INFO_SIZE_IN_BYTES, %cx
    movw $0x00, %ax
    rep                         # rep + stosb means: "Repeat copy %al (1 byte) to address (%es << 4) + %di, and decrease %cx by 1, until %cx == 0"
    stosb

    # If there is second disk (disk1)
is_disk1:

SETUP_MSG_LEN = 16
setup_msg:
    .ascii "setup is running"