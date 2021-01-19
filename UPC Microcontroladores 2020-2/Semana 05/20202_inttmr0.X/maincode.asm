;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librer�a de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuraci�n
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

    org 0x0000	    ;vector de reset
    goto init_conf

    org 0x0008	    ;vector interrupcion
    goto TMR0_ISR

    org 0x0020
init_conf:
    bcf TRISD, 1    ;RD1 como salida
    movlw 0x83	    
    movwf T0CON	    ;FOsc/4, 1:16 psc, 16bit
    movlw 0xA0
    movwf INTCON    ;GIE=1, TMR0IE=1
    
loop:		    ;Rutina principal, no hace nada
    nop
    nop
    nop
    goto loop
    
TMR0_ISR:
    btfss PORTB, 3
    goto apagado    ;cuando no es cierto
    btg LATD, 1	    ;cuando es cierto, toggle a RD1
    goto otro
apagado:
    bcf LATD, 1	    ;RD1 en cero
otro:
    bcf INTCON, TMR0IF	;Bajamos la bandera TMR0IF
    retfie	    ;Retorno de donde salto
    end