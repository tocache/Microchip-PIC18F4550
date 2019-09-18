    list p=18f4550
    #include<p18f4550.inc>
    
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
    
    org 0x0000
    goto meme
    
    org 0x0020
    ;Pasos para la configuracion del ADC:
    ;Configurar ADCON2 (tiempo de adquisicion)
    ;Configurar ADCON1 (puertos analogicos)
    ;Configurar ADCON0 (seleccion del canal analogico y control del ADC)
    ;Configurar si deseas interrupciones
meme:
    ;Configuracion del ADC
    movlw 0x24
    movwf ADCON2	;8TAD, FOsc/4, ADFM=0
    movlw 0x0E
    movwf ADCON1
    movlw 0x01
    movwf ADCON0
    clrf TRISD		;Salidas hacia LEDs
    
buclon:
    bsf ADCON0, 1	;Iniciamos la conversion
aunno:
    btfsc ADCON0, 1	;Preguntamos si termino de convertir
    goto aunno		;Aun no termina de convertir
    movff ADRESH, LATD	;Escribo el resultado de la conversion en RD
    goto buclon
    end
    


