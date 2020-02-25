    list p=18f4550
    #include<p18f4550.inc>

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x020		  ;GPR label declaration
	i_var
	j_var
	k_var
    endc

    org 0x0000		    ;Reset vector
    goto set_up
    
    org 0x0020
set_up:
	bcf TRISD, 0	    ;Set RD0 as output
begin:
	bsf LATD, 0
	call delay_1s
	bcf LATD, 0
	call delay_1s
	goto begin
	
delay_1s:
	movlw .100
	movwf i_var
oth1:	call nest1
	decfsz i_var, f
	goto oth1
	return
nest1:	movlw .100
	movwf j_var
oth2:	call nest2
	decfsz j_var, f
	goto oth2
	return
nest2:	movlw .100
	movwf k_var
oth3:	nop
	decfsz k_var, f
	goto oth3
	return
	
	end