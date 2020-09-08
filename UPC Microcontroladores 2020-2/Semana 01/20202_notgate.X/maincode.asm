    list p=18f4550		;modelo del microcontrolador
    #include<p18f4550.inc>	;librería de nombre de registros
 
    ;Aqui van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000			;dirección del vector de reset
    goto configuro		;salto a rutina de configuracion
    
    org 0x0020			;zona de programa de usuario
configuro:
    ;Aquí escribo las configuraciones
    bsf TRISB, 0		;pin RB0 como entrada
    bcf TRISD, 0		;pin RD0 como salida
    
inicio:
    ;La rutina principal de tu aplicación
    btfss PORTB, 0		;leo y pregunto si RB0 es uno
    goto falso			;viene aquí cuando fue falso
    bcf LATD, 0			;viene aquí cuando fue verdadero y RD0=0
    goto inicio			;vuelvo a hacer la rutina
falso:
    bsf LATD, 0			;RD0=1
    goto inicio
    end				;fin del programa
    