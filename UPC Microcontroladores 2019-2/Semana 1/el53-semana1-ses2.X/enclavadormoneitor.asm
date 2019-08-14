;Este es una prueba de comentario
;Plantilla hecha por Kalun Lau
;Microcontroladores - UPC 2019    
    
    list p=18f4550	    ;Modelo de uC a usar
    
;Directivas de preprocesador (bits de configuración)
    #include "p18f4550.inc" ;Librería de nombre de los registros
    CONFIG  FOSC = XT_XT    ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON       ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF       ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF       ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF    ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF       ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000		    ;Vector de RESET
    goto usuario
    
    org 0x0020		    ;Zona de programa
usuario:
    bcf TRISD, 0
loops:
    btfss PORTB, 0	    ;Preguntamos si el bot�n en RB0 fue presionado
    goto loops		    ;No se ha presionado el boton en RB0
    btfsc PORTD, 0	    ;Pregunto por el valor de la salida RD0
    goto uno
    bsf LATD, 0		    ;Pongo a cero el RD0
    goto detectacero
uno:
    bcf LATD, 0		    ;Pongo a uno el RD0
    goto detectacero
detectacero:
    btfsc PORTB, 0	    ;Pregunto si deje de presionar el boton en RB0
    goto detectacero	    ;Aun mantengo presionado el boton en RB0
    goto loops
    end







