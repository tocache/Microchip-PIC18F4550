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
	bcf TRISD, 0		;RD0 as output
	movlw 0xB1
	movwf T1CON		;Timer1 ON, FOsc/4, PSC 1:8
loop:	btfss PIR1, TMR1IF
	goto loop
	btg LATD, 0
	bcf PIR1, TMR1IF
	goto loop
	
	end

