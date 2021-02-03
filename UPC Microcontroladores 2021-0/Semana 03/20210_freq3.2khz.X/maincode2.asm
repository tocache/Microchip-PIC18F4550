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

    org 0x0008
    goto TMR0_ISR
    
    
;Aqu� se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    bcf TRISD, 2
    movlw 0xC8
    movwf T0CON
    movlw 0xA0
    movwf INTCON	;Habilitamos ints para TMR0
    
loop:
    goto loop

TMR0_ISR:
    btg LATD, 2    
    movlw .100
    movwf TMR0L
    bcf INTCON, TMR0IF
    retfie
    end