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
init_conf:
	    clrf TRISD	    ;Todo el puerto D como salida
loop:	    movf PORTB, W   ;Leo el puerto B y lo mando a W
	    andlw 0x0F	    ;Enmascaramiento para que pase solo RB0-RB3
	    ;Aplicando método PRO para duplicar el valor de entrada de datos
	    mullw .2	    ;Multiplico por 2 el W y se almacena el resultado en PRODL
	    movf PRODL, W   ;Mando a W el resultado de la multiplicación
	    call tabla_pc   ;LLamo a la subrutina tabla_pc
	    movwf LATD	    ;Escribo el W (proveniente de los retlw) hacia puerto D
	    goto loop

tabla_pc:   addwf PCL, f
	    retlw 0x3f		;Digito 0
	    retlw 0x06		;Digito 1
	    retlw 0x5b		;Digito 2
	    retlw 0x4f		;Digito 3
	    retlw 0x66		;Digito 4
	    retlw 0x6d		;Digito 5
	    retlw 0x7d		;Digito 6
	    retlw 0x07		;Digito 7
	    retlw 0x7f		;Digito 8
	    retlw 0x67		;Digito 9
	    
	    end		;Fin del programa