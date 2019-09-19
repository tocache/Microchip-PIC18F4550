    list p=18f4550
    #include "p18f4550.inc"
    #include "LCD_LIB.asm"
    
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x1000
cachanga da "Hello uc-haters "
    org 0x1100
picarones da "Canal AN0: "    
     
    org 0x0000
    goto hambrientos
    
    org 0x0020
hambrientos:
    ;Configuracion del ADC del micro
    ;Configuro ADCON2: tiempo de adquisicion y justificacion del resultado (ADFM)
    movlw 0x24
    movwf ADCON2
    ;Configuro ADCON1: determinar los puertos analogicos y voltajes de referencia
    movlw 0x0E
    movwf ADCON1
    ;Confoguro ADCON0: determino el canal que voy a leer y la activacion del modulo ADC
    movlw 0x01
    movwf ADCON0
    ;Configuracion del LCD
    movlw 0x08
    movwf TRISD
    call DELAY15MSEG
    call LCD_CONFIG
    call BORRAR_LCD
    call CURSOR_HOME
    call CURSOR_OFF
visfirstlain:
    ;Apuntar el TBLPTR hacia cachanga
    movlw LOW cachanga
    movwf TBLPTRL
    movlw HIGH cachanga
    movwf TBLPTRH
bucle1:
    TBLRD*+
    movf TABLAT, W
    call ENVIA_CHAR
    movlw .15
    cpfseq TBLPTRL
    goto bucle1
vissecondlain:
    movlw .0
    call POS_CUR_FIL2
;Apuntar el TBLPTR hacia picarones
    movlw LOW picarones
    movwf TBLPTRL
    movlw HIGH picarones
    movwf TBLPTRH
bucle2:
    TBLRD*+
    movf TABLAT, W
    call ENVIA_CHAR
    movlw .11
    cpfseq TBLPTRL
    goto bucle2
lecturadc:
    bsf ADCON0, 1		;Inicio la conversion en AN0
aunno:
    btfsc ADCON0, 1		;Pregunto si ya termino de convertir
    goto aunno
    movf ADRESH, W
    call BIN_BCD
    movf BCD2, W
    addlw 0x30
    call ENVIA_CHAR
    movf BCD1, W
    addlw 0x30
    call ENVIA_CHAR
    movf BCD0, W
    addlw 0x30
    call ENVIA_CHAR
    goto vissecondlain
;fin:goto fin
    end

