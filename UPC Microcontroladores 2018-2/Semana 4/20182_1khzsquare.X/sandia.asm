;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador(Single-Supply ICSP disabled)
    #include<p18f4550.inc>		;Llamo a la librería de nombre de los regs
  
    ;Zona de los bits de configuración (falta)
;    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (INTOSC = 8MHz)
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit t (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit

temporal EQU 0x0060
 
    org 0x0000				;Vector de RESET
    goto configuro

configuro:
	    bcf TRISD, 0		    ;Puerto D0 como salida para la onda cuadrada
	    movlw 0x62
	    movwf OSCCON	    ;Para que el oscilador interno funcione a 4MHz
	    movlw 0xC0
	    movwf T0CON		    ;Configuramos el Timer0 con Fosc/4 y PSC 1:2
	    
inicio:	    btfss INTCON, TMR0IF    ;Pregunto si se desbordó el Timer0
	    goto inicio
	    btfss PORTD, 0	    ;Pregunto si el puerto D0 está en uno
	    goto falso
	    bcf LATD, 0		    ;Verdadero, lo mando a cero el D0
	    goto otro
falso:	    bsf LATD,0
otro:	    bcf INTCON, TMR0IF	    ;Bajamos la bandera de desborde de Timer0
	    goto inicio
    
    
    end