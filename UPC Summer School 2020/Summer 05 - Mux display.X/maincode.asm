    list p=18f4550
    #include<p18f4550.inc>

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000		    ;Reset vector
    goto set_up
    
    org 0x0020
set_up:
	clrf TRISD
	movlw 0xFC
	movwf TRISB
	movlw 0x03		;Both displays disabled
	movwf LATB
loop:		
	movlw 0x79
	movwf LATD		;Load E character to RD
	bcf LATB, 0		;Enable first display
	call noops
	bsf LATB, 0		;Disable first display
	movlw 0x38
	movwf LATD		;Load L character to RD
	bcf LATB, 1		;Enable second display
	call noops
	bsf LATB, 1		;Disable second display
	goto loop
	
noops:	nop
	nop
	nop
	nop
	nop
	return
	
	end

