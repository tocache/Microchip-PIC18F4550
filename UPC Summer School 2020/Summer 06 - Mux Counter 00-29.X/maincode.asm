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
	cuenta
	decena
	unidad
    endc
  
    org 0x0600
tabla_7s db 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x67

    org 0x0000		    ;Reset vector
    goto set_up
    
    org 0x0008		    ;High Priority Interrupt Vector
    goto Tmr0_ISR
    
    org 0x0020
set_up:
	clrf TRISD		    ;Set RD port as output
	movlw 0xFC
	movwf TRISB		    ;Set RB1 and RB0 as outputs
	movlw LOW tabla_7s
	movwf TBLPTRL
	movlw HIGH tabla_7s
	movwf TBLPTRH	    ;Set address location for table pointer
	;Timer0 Setup:
	movlw 0xC8
	movwf T0CON	    ;Timer0 ON, PSC 1:1, 8bit mode
	;Interrupt Setup:
	movlw 0xA0
	movwf INTCON	    ;Interrupt enabled for Timer0
	clrf decena	    ;Clear variable decena
	clrf unidad	    ;Clear variable unidad
loop:	call delay_1s
	movlw .9
	cpfseq unidad
	goto non1
	clrf unidad
	movlw .2
	cpfseq decena
	goto non2
	clrf decena
	goto loop
non1:	incf unidad, f
	goto loop
non2:	incf decena, f
	goto loop
	
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
	
Tmr0_ISR:
	bcf INTCON, TMR0IF
	movf decena, W
	movwf TBLPTRL
	TBLRD*
	movff TABLAT, LATD	;Load decoded decena to RD
	bcf LATB, 0		;Enable first display
	call noops
	bsf LATB, 0		;Disable first display
	movf unidad, W
	movwf TBLPTRL
	TBLRD*
	movff TABLAT, LATD	;Load decoded decena to RD	
	;movwf LATD		;Load decoded unidad to RD
	bcf LATB, 1		;Enable second display
	call noops
	bsf LATB, 1		;Disable second display
	retfie
	
noops:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	return

	end

