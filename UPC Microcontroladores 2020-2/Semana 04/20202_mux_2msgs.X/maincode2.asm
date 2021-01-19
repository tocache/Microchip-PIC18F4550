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

;Aqu� va el cblock o declaaraci�n de nombres de GPR    
    cblock 0x000
    endc
    
    org 0x0000
    goto init_conf

;Aqu� se pueden declarar las constantes en la memoria de programa    
    org 0x0600
t_hola	db 0x76, 0x3F, 0x38, 0x77
    org 0x0610
t_upc	db 0x08, 0x3E, 0x73, 0x39	

    org 0x0020
init_conf:
    clrf TRISD		;Todo RD como salida
    movlw 0xF0
    movwf TRISB		;RB0-RB3 como salidas
    movlw 0x0F
    movwf LATB		;Los displays deshabilitados inicialmente
    movlw 0x06
    movwf TBLPTRH	;La parte HIGH de TBLPTR con valor 0x06
loop:
    btfss PORTB, 7	;PRegunto si RB7 es uno
    goto falso
verdad:
    movlw 0x10
    movwf TBLPTRL	;La parte inferior de TRLPTR es 0x10
    call multiplex
    goto loop
falso:
    movlw 0x00
    movwf TBLPTRL	;La parte inferior de TRLPTR es 0x10
    call multiplex
    goto loop
    
multiplex:    
    TBLRD*+		;Lee el contenido apuntado y luego incrementa el valor de la direcci�n del TBLPTR
    movff TABLAT, LATD		;Mandamos A
    movlw 0x07
    movwf LATB		;Activamos DS0
    nop
    movlw 0x0F
    movwf LATB		;Desactivamos DS0
    TBLRD*+
    movff TABLAT, LATD		;Mandamos A
    movlw 0x0B		;Activamos DS1
    movwf LATB
    nop
    movlw 0x0F		;Desactivamos DS1
    movwf LATB
    TBLRD*+
    movff TABLAT, LATD		;Mandamos A
    movlw 0x0D
    movwf LATB		;Activamos DS2
    nop
    movlw 0x0F
    movwf LATB		;Desactivamos DS2
    TBLRD*+
    movff TABLAT, LATD		;Mandamos A
    movlw 0x0E		;Activamos DS3
    movwf LATB
    nop
    movlw 0x0F		;Desactivamos DS3
    movwf LATB
    return
    end