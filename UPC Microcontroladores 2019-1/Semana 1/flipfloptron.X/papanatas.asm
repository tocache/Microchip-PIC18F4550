;Este es un comentario
;Plantilla para desarrollo de programas en MPASM
;Hecho por Kalun Lau
;UPC 2019
    
    list p=18f4550		;Modelo de microcontrolador PIC a usar
    #include "p18f4550.inc"	;librería de nombre de los registros

;Directivas de preprocesador (bits de configuración)    
    CONFIG  FOSC = XT_XT        ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON           ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF           ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF           ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF        ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF           ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de reset
    goto inicion
    
    org 0x0020
inicion:
    
    end
