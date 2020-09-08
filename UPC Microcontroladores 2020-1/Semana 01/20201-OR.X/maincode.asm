;Este es un comentario, se le antecede un punto y coma
    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a librería de nombre de los registros

    ;Declaración de los bits de configuración
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
    
    org 0x0000	;Vector de RESET
    goto init_conf
	
    org 0x0008	;Vector de interrupción
	
    org 0x0020	;Zona de programa de usuario
init_conf:  bcf TRISD, 0	;Puerto RD0 como salida
	    bsf	TRISB, 0	;Puerto RB0 como entrada
	    bsf TRISB, 1	;Puerto RB1 como entrada
loop:	    btfsc PORTB, 0	;Preguntamos si A es igual a cero
	    goto noes		;Viene para aquí si es falso lo anterior
	    btfsc PORTB, 1	;Viene para aquí si es verdadero y pregunta si B es igual a cero
	    goto noes		;Viene para aquí si es falso lo anterior
	    bcf LATD, 0		;Viene aquí cuando ambas condiciones se cumplen, pone a cero RD0
	    goto loop		;Retorna al inicio para volver a preguntar
noes:	    bsf LATD, 0		;Viene para aquí cuando AB son 01, 10 y 11. Pone a uno RD0
	    goto loop		;Retorna al inicio para volver a preguntar
	    end


