;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuración
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000		;Vector de RESET
    goto init_conf
    
    org 0x0008		;Vector de interrupción
    
    org 0x0020		;Zona de programa de usuario
init_conf:  bcf TRISD, 0    ;Puerto RD0 como salida
	    bsf TRISB, 0    ;Puerto RB0 como entrada
	    bsf TRISB, 1    ;Puerto RB1 como entrada
loop:	    btfss PORTB, 0  ;Pregunto si el bit 0 de PORTB es igual a uno
	    goto noes	    ;Cuando es falso y salto a noes
	    btfss PORTB, 1  ;Pregunto si el bit 1 de PORTB es igual a cero
	    goto noes	    ;Cuando es falso y salto a noes
	    bcf LATD, 0	    ;Cuando ambas condiciones son verdades, pone a cero RD0
	    goto loop	    ;Retorna a loop para volver a hacer la tarea
noes:	    bsf LATD, 0	    ;Cuando son las demas condicionales, pone a uno RD0
	    goto loop	    ;Retorna a loop para volver a hacer la tarea
	    end		;Fin del programa