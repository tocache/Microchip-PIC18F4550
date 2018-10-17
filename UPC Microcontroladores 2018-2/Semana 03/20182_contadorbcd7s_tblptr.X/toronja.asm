;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador(Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bi
    #include<p18f4550.inc>		;Llamo a la librería de nombre de los regs
    
    ;Zona de los bits de configuración (falta)
;    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (INTOSC = 8MHz)
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit t (MCLR pin enabled; RE3 input pin disabled)

    
    org 0x0100
datos db 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x67

cuenta EQU 0x0063
    
    org 0x0000				;Vector de RESET
    goto configuro

configuro:  clrf TRISB
	    clrf TBLPTRU
	    movlw HIGH datos
	    movwf TBLPTRH
	    movlw LOW datos
	    movwf TBLPTRL

cero:	    clrf cuenta		;Para que empiece en cero
	    ;movlw .2			;Para que empiece en dos
	    ;movwf cuenta

inicio:	    movlw .9
	    cpfsgt cuenta
	    goto aunno
	    goto cero
aunno:	    movf cuenta, W
	    movwf TBLPTRL
	    TBLRD*
	    movff TABLAT, LATB
	    call retardo
	    incf cuenta, f
;	    incf cuenta, f		;Cuente de dos en dos
	    goto inicio

retardo:
    movlw .100
    movwf 0x60
otro1:
    call bucle1
    decfsz 0x60, 1
    goto otro1
    return
bucle1:
    movlw .10
    movwf 0x61
otro2:
    call bucle2
    decfsz 0x61, 1
    goto otro2
    return
bucle2:
    movlw .10
    movwf 0x62
otro3:
    nop
    decfsz 0x62, 1
    goto otro3
    return

    end