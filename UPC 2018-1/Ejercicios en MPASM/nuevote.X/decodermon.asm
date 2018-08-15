    list p=18f4550
    #include "p18f4550.inc"

    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))    
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
 
    cblock 0x60
	temporal
	endc

	org 0x100
tablaton db 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, 0x7F
 
	org 0x000
	goto papanatas
	
	org 0x020
papanatas:
	movlw UPPER tablaton
	movwf TBLPTRU
	;clrf TRLPTRU
	movlw HIGH tablaton
	movwf TBLPTRH
	movlw LOW tablaton
	movwf TBLPTRL
	
	movlw 0x63
	movwf OSCCON		;Oscilador interno a 4MHz
	clrf TRISD, 0
	movlw 0x0F
	movwf TRISB

inicio:	movf PORTB, W
	andlw 0x0F
	movwf temporal
	movlw 0x0A
	cpfsgt temporal
	goto todobien
	movlw 0x0A
	movwf TBLPTRL
	goto lectura
todobien:
	movf temporal, W
	movwf TBLPTRL
lectura:
	TBLRD*
	movff TABLAT, LATD	
	goto inicio
	end
	