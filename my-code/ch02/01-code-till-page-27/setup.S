GREEN_COLOR = 0x0a

INTERRUPTION_TO_DISPLAY_CHARACTER = 0x10

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

SETUP_MSG_LEN = 16
setup_msg:
    .ascii "setup is running"