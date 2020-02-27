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
	pos
	disp1
	disp2
    endc
  
    org 0x0600
msg_upc db 0x00, 0x00, 0x00, 0x3E, 0x73, 0x39, 0x00, 0x00, 0x00
    org 0x0700
msg_upc2 db 0x00, 0x00, 0x00, 0x39, 0x73, 0x3E, 0x00, 0x00, 0x00
 
    org 0x0000		    ;Reset vector
    goto set_up
    
    org 0x0008		    ;High Priority Interrupt Vector
    goto Tmr0_ISR
    
    org 0x0018
    goto Int2_ISR	    ;Low Priority Interrupt Vector
    
    org 0x0020
set_up:
	clrf TRISD		    ;Set RD port as output
	movlw 0xFC
	movwf TRISB		    ;Set RB1 and RB0 as outputs
	movlw LOW msg_upc
	movwf TBLPTRL
	movlw HIGH msg_upc
	movwf TBLPTRH	    ;Set address location for table pointer
	;Timer0 Setup:
	movlw 0xC8
	movwf T0CON	    ;Timer0 ON, PSC 1:1, 8bit mode
	;Interrupt Setup:
	bsf RCON, IPEN	    ;Enabling priority interrupt system
	bcf INTCON3, INT2IP ;Setting INT2 as low priority interrupt
	bsf INTCON3, INT2IE ;Enabling INT2 interrupt
	movlw 0xE0
	movwf INTCON	    ;Interrupt enabled for Timer0
	clrf pos	    ;Clear pos variable
loop:	movf pos, W
	movwf TBLPTRL
	TBLRD*+
	movff TABLAT, disp1
	TBLRD*
	movff TABLAT, disp2
	call delay_1s
	movlw .7
	cpfseq pos
	goto desplazar
	clrf pos
	goto loop
desplazar:
	incf pos, f
	goto loop
	
delay_1s:
	movlw .100
	movwf i_var
oth1:	call nest1
	decfsz i_var, f
	goto oth1
	return
nest1:	movlw .50
	movwf j_var
oth2:	call nest2
	decfsz j_var, f
	goto oth2
	return
nest2:	movlw .10
	movwf k_var
oth3:	nop
	decfsz k_var, f
	goto oth3
	return	
	
Tmr0_ISR:
	bcf INTCON, TMR0IF
	movff disp1, LATD	;Load decoded decena to RD
	bcf LATB, 0		;Enable first display
	call noops
	bsf LATB, 0		;Disable first display
	movff disp2, LATD	;Load decoded decena to RD	
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

Int2_ISR:
	    movlw 0x06
	    cpfseq TBLPTRH
	    goto nooooo
	    movlw 0x07
	    movwf TBLPTRH
	    goto final
nooooo:	    movlw 0x06
	    movwf TBLPTRH
final:	    clrf pos
	    bcf INTCON3, INT2IF
	    retfie
	    
	    
	end



