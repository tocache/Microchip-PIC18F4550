    list p=18f4550
    #include<p18f4550.inc>

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000		    ;RESET Vector
    goto configuro
    
    org 0x0008		    ;High priority Int vector
    goto int_high
    
    org 0x0018
    goto int_low
    
    org 0x0020
configuro:
    bcf TRISD, 0
    bcf TRISD, 4
    bsf RCON, IPEN	    ;Enable priority interrupts
    bcf INTCON3, INT1IP	    ;INT1 as low priority
    bsf INTCON3, INT1IE	    ;INT1 enabled
    bsf INTCON, INT0IE	    ;INT0 enabled
    bsf INTCON, GIEL	    ;Low priority ints enabled
    bsf INTCON, GIEH	    ;High priority ints enabled
    
inicio:
    goto inicio
    
int_high:    
    btg LATD, 0
    bcf INTCON, INT0IF	    ;bajamos bandera del INT0
    retfie
    
int_low:
    btg LATD, 4
    bcf INTCON3, INT1IF	    ;bajamos bandera de INT1
    retfie
    
    end

