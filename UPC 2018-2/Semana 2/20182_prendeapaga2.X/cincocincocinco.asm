    list p=18f4550
    #include <p18f4550.inc>
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

variable_i EQU 0x060
variable_j EQU 0x061
variable_k EQU 0x062
 
    org 0x0000				;Vector de RESET
    goto configuro
    
    org 0x0020
configuro:
	    bcf TRISB, 3	   ;Puerto RB3 como salida

inicio:
	bsf LATB, 3		    ;Encendemos el LED conectado en RB3
	call retrasados			    ;Instrucción de "no operación"
	bcf LATB, 3		    ;Apagamos el LED conectado en RB3
	call retrasados
	goto inicio

retrasados:
	    movlw .100		    ; 0x20 d'100' b'00100000'
	    movwf variable_i
otro1:	    call bucle1
	    decfsz variable_i, 1
	    goto otro1
	    return

bucle1:	    movlw .100
	    movwf variable_j
otro2:	    call bucle2
	    decfsz variable_j, 1
	    goto otro2
	    return

bucle2:	    movlw .10
	    movwf variable_k
otro3:	    decfsz variable_k, 1
	    goto otro3
	    return
	    
	end