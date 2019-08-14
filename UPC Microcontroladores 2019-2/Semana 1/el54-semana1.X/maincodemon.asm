;Programa hecho por Kalun
;UPC Monterrico
;13 de Agosto del 2019
    
    list p=18f4550	    ;modelo de microcontrolador
    #include<p18f4550.inc>  ;llamada a la libreria de nombres
    
;Aqui van los bits de configuracion (directivas de pre procesador)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
   
    org 0x0000		    ;vector de RESET
    goto confegoro
    
    org 0x0020		    ;Inicio del area de programa de usuario
confegoro:
    bcf TRISD, 0	    ;Puerto RD0 como salida
    ;bsf TRISB, 0	    ;Puerto RB0 como entrada (esta de mas...)
    ;clrf LATD		    ;Por las puras

inicio:
    btfss PORTB, 0
    goto falsaso
    bcf LATD, 0
    goto inicio
falsaso:
    bsf LATD, 0
    goto inicio
    end
    