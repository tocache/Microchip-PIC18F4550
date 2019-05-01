    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;Librería de nombres
    
    ;Zona de los bits de configuración del microcontroleitor    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)


    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0008			;Vector de interrupción
    goto memachucaron
    
    org 0x0020
configura:
    bcf TRISD, 0	    ;Puerto donde esta conectado el relay
    movlw 0x90
    movwf INTCON	    ;Interrupciones activadas para INT0

inicio:
    sleep
    goto inicio
    
memachucaron:
    btg LATD, 0
    bcf INTCON, INT0IF	    ;Bajamos la bandera de INT0
    retfie
    
    end