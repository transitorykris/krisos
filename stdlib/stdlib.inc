; KrisOS - stdlib.h

; Zero page
nmi_ptr = $FC                   ; Location of NMI routine
irq_ptr = $FE                   ; Location of IRQ routine

; Library routines
write = $d000
