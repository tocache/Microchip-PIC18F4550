;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador
    #include<p18f4550.inc>		;Llamo a la librería de nombre de los regs
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = XT_XT	  ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    
cuenta EQU 0x60
 
	org 0x0100
datos db 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x67
 
	org 0x0000
	goto configuro
	
	org 0x0008
	goto interro0p
	
	org 0x0018
	goto interro1p
	
	org 0x0020
configuro:  clrf TRISD	    	;Puerto RD5 como salida, conectado a un LED
	    clrf cuenta
	    movlw UPPER datos
	    movwf TBLPTRU
	    movlw HIGH datos
	    movwf TBLPTRH
	    movlw LOW datos
	    movwf TBLPTRL	;Punteando el TBLPTR
	    bsf RCON, IPEN	;Habilitamos las interrupciones por prioridad
	    bcf INTCON3, INT1IP	;La interrución INT1 es de baja prioridad
	    bsf INTCON3, INT1IE	;Habilitamos la INT1
	    movlw 0xD0
	    movwf INTCON	;Interrupciones altas y bajas activas, INT0 habilitado

inicio:	    movf cuenta, W
	    movwf TBLPTRL
	    TBLRD*
	    movff TABLAT, LATD
	    goto inicio
	    
interro0p:  movlw .9
	    cpfseq cuenta
	    goto aunno1
	    clrf cuenta
	    goto otro1
aunno1:	    incf cuenta, f
otro1:	    bcf INTCON, INT0IF
	    retfie

interro1p:  movlw .0
	    cpfseq cuenta
	    goto aunno2
	    movlw .9
	    movwf cuenta
	    goto otro2
aunno2:	    decf cuenta, f
otro2:	    bcf INTCON3, INT1IF
	    retfie
	    
	    
	    end