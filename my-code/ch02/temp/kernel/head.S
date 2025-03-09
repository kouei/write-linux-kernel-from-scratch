SEGMENT_SELECTOR = 0x18
# 0x18 = 0b00011000
# bit 0 ~ 1  = RPL, Request Privilege Level
# bit 2      = TI, means whether the selector is for local or global
# bit 3 ~ 15 = Actual index
# Hence:
# RPL = 00, means the privilege level = 0
# actual index = 0b11 = 3, means we are selecting the item whose index is 3 in the GDT (Global Descriptor Table)

.code32 # head.S should be compiled in 32-bit mode
.text
.global startup_32 # export symbol startup_32
startup_32:
    movl $SEGMENT_SELECTOR, %eax
    movw %ax, %gs
    movl $0x0, %edi
    movb $0xf, %ah
    movb $0x42, %al
    movw %ax, %gs:(%edi)

    movl $0x10, %eax # 0x10 = 0b00010000, means we are selecting the item whose index is 2 in the GDT (Global Descriptor Table)
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs

loop:
    jmp loop