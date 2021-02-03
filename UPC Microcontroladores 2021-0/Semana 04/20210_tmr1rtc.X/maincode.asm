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
    var_disp
    endc
    
    org 0x0000
    goto init_conf
    
    org 0x0008
    goto TMR1_ISR

;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    movlw 0xF0
    movwf TRISD
    movlw 0x07
    movwf T1CON
    movlw 0x80
    movwf TMR1H
    clrf TMR1L
    movlw 0xC0
    movwf INTCON
    movlw 0x01
    movwf PIE1
    clrf var_disp
    
loop:
    goto loop
    
TMR1_ISR:
    movlw 0x80	    
    movwf TMR1H
    clrf TMR1L	    ;tejec = 3us cumpliendo que se suba la cta inicial antes de los 15.25us
    movlw .9
    cpfseq var_disp
    goto aunno
    clrf var_disp
    goto final
aunno:
    incf var_disp, f
final:
    movff var_disp, LATD
    bcf PIR1, TMR1IF
    retfie
    end