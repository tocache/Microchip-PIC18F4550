;Los comentarios van antecedidos de un punto y coma
    
    list p=18f4550	    ;Modelo del microcontrolador
    #include <p18f4550.inc> ;Librería de nombres de los registros
    
    ;Zona de declaración de los bits de configuración del microcontrolador
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

    org 0x0000		    ;Vector de RESET
    goto init_conf
    
    org 0x0008		    ;Vector de interrupcion
    
    org 0x0020		    ;Zona de programa de usuario
init_conf:
	    bcf TRISD, 0    ;Hacer que el puerto RD0 sea una salida
	    bsf TRISB, 0    ;Hacer que el puerto RB0 sea una entrada
loop:	    btfss PORTB, 0  ;Leer y preguntar si RB0 es uno
	    goto falso	    ;Cuando se obtiene un falso, salta a etiqueta falso
	    bcf LATD, 0	    ;Cuando se obtiene un verdadero, manda cero a RD0
	    goto loop	    ;Salta a etiqueta loop
falso:	    bsf LATD, 0	    ;Manda uno a RD0
	    goto loop	    ;Salta a etiqueta loop    
	    end		    ;Fin del programa
    
    

