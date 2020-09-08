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

cuenta EQU 0x020	;La posicion 0x100 de la memoria de datos se llamara cuenta
    
    org 0x0000		;Vector de RESET
    goto init_conf
 
    org 0x0500
datos db 0x04, 0xAF, 0xBE, 0x89    
    
    org 0x0020		;Zona de programa de usuario
init_conf:
    clrf TRISD		;RD como salida
    ;movlw UPPER datos
    ;movwf TBLPTRU	no es necesario debido a que el puntero es de 15 bits
    movlw HIGH datos
    movwf TBLPTRH
    movlw LOW datos
    movwf TBLPTRL	;Dirección del TBLPTR apuntada a 0x500
    
loop:
    TBLRD*		;Accion de lectura de lo apuntado por TBLPTR
    movff TABLAT, LATD	;Muevo el contenido de TABLAT a RD
    nop			;Microretardo
    incf TBLPTRL,f	;Incremento la posicion de TBLPTR
    TBLRD*
    movff TABLAT, LATD
    nop
    incf TBLPTRL,f
    TBLRD*
    movff TABLAT, LATD
    nop
    incf TBLPTRL, f
    TBLRD*
    movff TABLAT, LATD
    goto loop
    end
    