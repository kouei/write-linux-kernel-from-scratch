BOOTSEG = 0x7c0

.code16
.text

.global _start
_start:
    jmpl $BOOTSEG, $start2

start2:
    movw $BOOTSEG, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs

    movw $msg, %ax
    movw %ax, %bp
    movw $0x01301, %ax    # %ah = 0x13 means display character string in teletype mode, %al = 0x01 means character string not only contains characters, but also properties of how should we display them  (e.g., color)
    movw $0x0c, %bx       # Set text color to red
    movw $12, %cx         # Text length = 12
    movb $0, %dl          # Position of the cursor, row number = %dh, column number = %dl
    int $0x010            # Trigger interruption 0x010 to notify graphics card to refresh content,

loop:
    jmp loop

msg:
.ascii "Hello World!"

.org 510
boot_flag:
    .word 0xaa55
    