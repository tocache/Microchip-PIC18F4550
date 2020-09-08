    list p=18f4550		;modelo del microcontrolador
    #include <p18f4550.inc>	;libreria de nombre de registros
    
    ;Aqui van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de RESET
    goto configuro
    
    org 0x0020			;Zona de programa de usuario
configuro:
    bcf TRISD, 0		;establecemos RD0 como salida
    bsf TRISB, 0		;establecemos RB0 como entrada
    bsf TRISB, 0		;establecemos RB1 como entrada
principal:
    btfss PORTB, 0		;leo y pregunto si RB0=1
    goto falso			;salto aqui si es falso
    btfss PORTB, 1		;salto aqui si es verdadero y pregunto si RB1=1
    goto falso			;salto aqui si es falso
    bsf LATD, 0			;salto aqui si es verdadero y coloco RD0=1
    goto principal		;vuelvo a repetir la rutina
falso:
    bcf LATD, 0			;coloco RD0=0
    goto principal		;vuelvo a repetir la rutina
    end				;Final del codigo