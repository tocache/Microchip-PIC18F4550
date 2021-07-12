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
    
    org 0x0000
    goto 0x0030
    org 0x0100
    db 0x56, 0x55
    org 0x0030
    comf 0xF95, 1
    lfsr 2, 0x005
    clrf 0xFF8
    movlw 0xFF
    andlw 0x01
    movwf 0xFF7
    clrf 0xFF6
    TBLRD*
    movf 0xFF5, 0
    movwf 0xFEF
    incf 0xFF6, 1
    TBLRD*
    movf 0xFEF, 0
    cpfsgt 0xFF5
    bra $+8
    movlw 0x55
    movwf 0xF83
    bra $+6
    movlw 0xAA
    movwf 0xF83
    nop
    goto $
    end

begin:    
    clrf TBLPTRU
    movlw 0x03
    movwf TBLPTRH
    movlw 0x50
    movwf TBLPTRL
    bra inicio
    