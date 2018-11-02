    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;librería de nombres

    ;Zona de los bits de configuración del microcontroleitor    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020
configura:
    bcf TRISD, 0		;Puerto D0 como salida
    movlw 0xC8
    movwf T0CON			;Configuración del Timer0
    
inicio:
    movlw .6
    movwf TMR0L			;Cuenta inicial del Timer0
papa:
    btfss INTCON, TMR0IF	;Pregunto si se ha desbordado Timer0
    goto papa			;Cuando no se ha desbordado
    clrf INTCON, TMR0IF		;Bajamos la bandera de desborde
    btg LATD, 0			;Complemento de D0 cuando se desbordó
    goto inicio
    end