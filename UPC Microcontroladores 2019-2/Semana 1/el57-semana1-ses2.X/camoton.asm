;Este es un comentario
;Programa desarrollado por Kalun Lau
;UPC Monterrico 14 de agosto del 2019
    
    list p=18f4550		    ;Modelo del microcontrolador
    #include <p18f4550.inc>	    ;Libreria de nombre de los registros
    
    ;Aqui deben de estar los bits de configuracion o directivas de preprocesador
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			    ;Vector de RESET
    goto confeg
    
    org 0X0020			    ;Zona de programa de usuario
confeg:
    bcf TRISD, 0		;Puerto RD0 como salida
				;No se declaran los puertos que son entradas!
loopos:
    btfss PORTB, 0		;Pregunto si RB0 es uno
    goto fooolso		;Salta aqui si es falso
    bcf LATD, 0			;Salta aqui si es verdadero y RD0 es cero
    goto loopos			;Regreso a preguntar el RB0
fooolso:
    bsf LATD, 0			;RD0 es uno
    goto loopos			;Regreso a preguntar el RB0
    end
    


