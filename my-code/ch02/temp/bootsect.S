SYSSIZE = 0x3000

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

    rep                  # rep + movsw means: "Repeat copy a word (2 bytes) from address (%ds << 4) + %si to address (%es << 4) + %di, and decrease %cx by 1, until %cx == 0"
    movsw

    jmpl $INITSEG, $go   # Does two things, 1) set %cs = $INITSEG, 2) jump to $go label

go:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0xFF00, %sp    # Not necessary here, but it's a good habit to set stack pointer to a meaningful.

load_setup:
    movb $0x00, %dh      # %dh means the id of magnetic head
    movb $0x00, %dl      # %dl means drive id, 0 means floppy disk, 7 means hard disk.
    movb $0x00, %ch      # %ch means the lower 8 bits of cylinder id.
    movb $0x02, %cl      # The first 0~5 bits in %cl means start sector id, 6~7 bits means the higher 2 bits of magnetic track
    movw $SECTOR_SIZE_IN_BYTES, %bx    # (%es << 4) + %bx is the address of the buffer. If there is any error, the CF bit will be set
    movb $SETUPLEN, %al  # %al means the number of sectors to load
    movb $0x02, %ah      # %ah == 0x02 means: load sector (512 bytes) from disk to memory
    int  $INTERRUPTION_TO_LOAD_FLOPPY_DISK
    jnc  ok_load_setup    # If CF == 0, then jump to ok_load_setup; Otherwise if CF == 0, don't jump.
    movw $0x0000, %dx
    movw $0x0000, %ax    # %ah == 0x0 means reset disk
    int  $INTERRUPTION_TO_LOAD_FLOPPY_DISK # When %ah == 0, this interruption will reset disk
    jmp  load_setup       # load setup failed, jump to load_setup to retry

ok_load_setup:
	movb $0x00, %dl
	movw $0x0800, %ax
	int  $0x13
	movb $0x00, %ch
	movw %cx, %cs:sectors
	movw $INITSEG, %ax
	movw %ax, %es

	movw $SYSSEG, %ax
	movw %ax, %es
	call read_it
	call kill_motor

	movw %cs:root_dev, %ax
	cmpw $0, %ax
	jne  root_defined
	movw %cs:sectors, %bx
	movw $0x0208, %ax
	cmpw $15, %bx
	je   root_defined
	movw $0x021c, %ax
	cmpw $18, %bx
	je   root_defined
undef_root:
	jmp  undef_root
root_defined:
	mov  %ax, %cs:root_dev

	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es

	movw $0x600, %ax
	movw $0x700, %bx
	movw $0x0,   %cx
	movw $0x184f,%dx
	int  $0x10

	movw $msg, %ax
	movw %ax, %bp
	movw $0x01301, %ax
	movw $0x0c, %bx
	movw $23, %cx
	movw $0, %dx
	int  $0x010

	jmpl $SETUPSEG, $0

sread:
	.word 1+SETUPLEN
head:
	.word 0
track:
	.word 0
read_it:
	movw %es, %ax
	testw $0x0fff, %ax
die:
	jne die
	xor %bx, %bx
rp_read:
	movw %es, %ax
	cmpw $ENDSEG, %ax
	jb   ok1_read
	ret
ok1_read:
	movw %cs:sectors, %ax
	subw sread, %ax
	movw %ax, %cx
	shlw $9,  %cx
	addw %bx, %cx
	jnc  ok2_read
	je   ok2_read
	xorw %ax, %ax
	subw %bx, %ax
	shrw $9,  %ax
ok2_read:
	call read_track
	movw %ax, %cx
	addw sread, %ax
	cmpw %cs:sectors, %ax
	jne  ok3_read
	movw $1, %ax
	subw head, %ax
	jne  ok4_read
	incw track
ok4_read:
	movw %ax, head
	xorw %ax, %ax
ok3_read:
	movw %ax, sread
	shlw $9,  %cx
	addw %cx, %bx
	jnc  rp_read
	movw %es, %ax
	addw $0x1000, %ax
	movw %ax, %es
	xorw %bx, %bx
	jmp  rp_read

read_track:
	pushw %ax
	pushw %bx
	pushw %cx
	pushw %dx
	movw  track, %dx
	movw  sread, %cx
	incw  %cx
	movb  %dl, %ch
	movw  head, %dx
	movb  %dl, %dh
	movb  $0, %dl
	andw  $0x0100, %dx
	movb  $2, %ah
	int   $0x13
	jc    bad_rt
	popw  %dx
	popw  %cx
	popw  %bx
	popw  %ax
	ret
bad_rt:
	movw $0x0, %ax
	movw $0x0, %dx
	int  $0x13
	popw %dx
	popw %cx
	popw %bx
	popw %ax
	jmp read_track

kill_motor:
	pushw %dx
	movw  $0x3f2, %dx
	movb  $0,  %al
	outb  %al, %dx
	popw  %dx
	ret

sectors:
	.word 0

msg:
.byte 13, 10
.ascii "Linux is booting..."
.byte 13, 10
.org 508
root_dev:
	.word ROOT_DEV
boot_flag:
	.word 0xaa55

