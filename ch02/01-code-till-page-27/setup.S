RED_COLOR = 0x0c

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
    movw $0x01301, %ax       # %ah = 0x13 means display character string in teletype mode, %al = 0x01 means character string not only contains characters, but also properties of how should we display them  (e.g., color)
    movw $RED_COLOR, %bx
    movw $SETUP_MSG_LEN, %cx
    movb $3, %dh             # Start position of where to print characters, row number = %dh, column number = %dl
    movb $0, %dl
    int $INTERRUPTION_TO_DISPLAY_CHARACTER

SETUP_MSG_LEN = 16
setup_msg:
    .ascii "setup is running"