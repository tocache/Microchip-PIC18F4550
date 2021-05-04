;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librer�a de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuraci�n
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG FOSC = INTOSCIO_EC
    ;CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000			    ;Vector de RESET
    goto init_conf
    
    org 0x0020			    ;Zona de programa de usuario
init_conf:  bsf OSCCON, 6
	    bsf OSCCON, 5
	    bcf OSCCON, 4	    ;INTOSC trabajando a 4MHz
	    bcf TRISD, 6	    ;RD6 como salida
	    movlw 0xC0
	    movwf T0CON		    ;TMR0 on, fosc/4, 1:2 psc, 8bit
loop:	    movlw .13
	    movwf TMR0L		    ;Cuenta inicial de 6
aunno:	    btfss INTCON, TMR0IF    ;Pregunto si se desbordo TMR0
	    goto aunno		    ;No se desbordo
	    btg LATD, 6		    ;Basculo RD6
	    nop
	    nop
	    bcf INTCON, TMR0IF	    ;Bajamos la bandera TMR0IF
	    goto loop
	    end