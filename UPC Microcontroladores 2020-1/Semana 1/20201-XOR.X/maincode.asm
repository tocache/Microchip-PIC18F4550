;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador a usar
    #include <p18f4550.inc> ;Declaración de la librería de nombres de los registros

    ;Zona de los bits de configuración
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
init_conf:
		bcf TRISD, 0	    ;Puerto RD0 como salida
		bsf TRISB, 0	    ;Puerto RB0 como entrada
		bsf TRISB, 1	    ;Puerto RB1 como entrada
loop:		btfsc PORTB, 0
		goto noes1
		btfsc PORTB, 1
		goto noes2
outzero:	bcf LATD, 0
		goto loop
noes2:		bsf LATD, 0
		goto loop
noes1:		btfss PORTB, 1
		goto noes2
		goto outzero
		end	;Fin del programa


