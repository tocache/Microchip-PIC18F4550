;Este es una prueba de comentario
;Plantilla hecha por Kalun Lau
;Microcontroladores - UPC 2019    
    
    list p=18f4550	    ;Modelo de uC a usar
    
;Directivas de preprocesador (bits de configuracio)
    #include "p18f4550.inc" ;Libreria de nombre de los registros

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
    bcf TRISB, 7	    ;RB7 como salida (X del MUX)
luper:
    btfss PORTD, 0
    goto fals1
    btfss PORTD, 1
    goto fals2
    btfss PORTB, 3
    goto nuuu1
    bsf LATB, 7
    goto luper
nuuu1:
    bcf LATB, 7
    goto luper
fals2:
    btfss PORTB, 2
    goto nuuu2
    bsf LATB, 7
    goto luper
nuuu2:
    bcf LATB, 7
    goto luper
fals1:    
    btfss PORTD, 1
    goto fals3
    btfss PORTB, 1
    goto nuuu3
    bsf LATB, 7
    goto luper
nuuu3:
    bcf LATB, 7
    goto luper
fals3:
    btfss PORTB, 0
    goto nuuu4
    bsf LATB, 7
    goto luper
nuuu4:
    bcf LATB, 7
    goto luper
    end




