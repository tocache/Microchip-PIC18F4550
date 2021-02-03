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

;Aquí va el cblock o declaaración de nombres de GPR    
    cblock 0x000
    valor_entrada
    endc
    
    org 0x0000
    goto init_conf

;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    clrf TRISD	    ;Todo RD como salida

loop:
    movf PORTB, w	    ;Lectura del contenido de RB
    andlw 0x0F		    ;Enmascaramiento para que pasen RB3-RB0
    movwf valor_entrada	    ;Paso el contenido de W hacia valor_entrada
    call tabla_pc
    movwf LATD
    goto loop
    
tabla_pc:
    movf valor_entrada, w	;jalo valor_entrada a w
    addwf valor_entrada, f	;sumo contenido de w con valor_entrada y lo almaceno en este ultimo
    movf valor_entrada, w	;jalo nuevamente valor_entrada (ya multiplicado por dos)
    addwf PCL, f		;tabla de busqueda con contador de programa
    retlw 0x3F			;retorno de subrutina acompaniando un literal
    retlw 0x06
    retlw 0x5B
    retlw 0x4F
    retlw 0x66
    retlw 0x6D
    retlw 0x7D
    retlw 0x07
    retlw 0x7F
    retlw 0x67
    retlw 0x79
    retlw 0x79
    retlw 0x79
    retlw 0x79
    retlw 0x79
    retlw 0x79
    
    end