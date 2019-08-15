;Este es un comentario
;Plantilla desarrollada por Kalun Lau
;UPC Monterrico 14 de agosto del 2019

    list p=18f4550		    ;Modelo de microcontrolador a emplear
    #include<p18f4550.inc>	    ;Libreria de nombres de registros
    
    ;Aqui deben de ir la declaracion de los bits de configuracion (directivas de preprocesador)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			    ;Vector de RESET
    goto confog
    
    org 0x0020			    ;Zona de programa de usuario
confog:
    bcf TRISD, 0		    ;Puerto RD0 como salida
				    ;Las entradas no se declaran!
looper:
    btfss PORTB, 0		    ;Pregunto si RB0 es igual a uno
    goto falsaaaaaso		    ;Salta aqui cuando es FALSO
    bcf LATD, 0			    ;Salta aqui cuando es VERDADERO y pone RD0 a cero
    goto looper			    ;Salto hacia etiqueta 'looper'
falsaaaaaso:
    bsf LATD, 0			    ;Pone RD0 a uno
    goto looper			    ;Salto hacia etiqueta 'looper'
    end				    ;Fin del programa


