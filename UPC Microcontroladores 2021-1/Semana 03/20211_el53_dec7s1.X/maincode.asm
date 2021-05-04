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
    CONFIG  MCLRE = OFF            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000
    goto init_conf

    ;Lo de lineas se almacenara de manera secuencial desde la 0x0300 en la mem prog
    org 0x0500
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
    
    org 0x0020
init_conf:
    movlw 0x80
    movwf TRISD		    ;RD6-RD0 como salidas
    movlw HIGH tabla_7s
    movwf TBLPTRH
    movlw LOW tabla_7s
    movwf TBLPTRL	    ;TBLPTR apunta a 0x0500 de la mem de prog.
    
loop:
    movf PORTB, W	;Leemos RB y lo dejamos en Wreg
    andlw 0x0F		;Enmascaras los cuatro primeros bits de Wreg
    movwf TBLPTRL	;Escribimos Wreg en TBLPTRL (registro menos significativo del puntero de tabla)
    TBLRD*		;Lectura del contenido apuntado por TBLPTR y lo almacena en TABLAT
    movff TABLAT, LATD
    goto loop

    end
    