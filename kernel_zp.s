; KrisOS Zeropage globals for Kernel
; Copyright 2020 Kris Foster

.ifndef _KERNEL_ZP_
_KERNEL_ZP_ = 1

    .exportzp nmi_ptr
    .exportzp irq_ptr

    .segment "USERVECTORS": zeropage
nmi_ptr:    .res 2              ; Location of NMI routine
irq_ptr:    .res 2              ; Location of IRQ routine

.endif