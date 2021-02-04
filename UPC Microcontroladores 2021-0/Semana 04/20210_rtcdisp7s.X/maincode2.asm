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
    
    org 0x0018
    goto INT1_ISR

;Aquí se pueden declarar las constantes en la memoria de programa    
    org 0x0600
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79    

    org 0x0020
init_conf:
    movlw 0x80
    movwf TRISD
    movlw HIGH tabla_7s
    movwf TBLPTRH
    clrf TBLPTRL	;TBLPTR apuntando a 0x0600
    movlw 0x0E		
    movwf T1CON		;TMR1 osc enabled, 1:1 PSC, async
    movlw 0x80
    movwf TMR1H
    clrf TMR1L		;Carga inicial de cuenta en TMR1
    bsf RCON, IPEN	;Habilito prioridades en interrupciones
    bcf INTCON3, INT1IP	;INT1 en baja prioridad
    bcf INTCON2, INTEDG1;INT1 en falling edge
    bsf INTCON3, INT1IE	;Habilito INT1
    movlw 0x01
    movwf PIE1		;TMR1 int enabled
    movlw 0xC0
    movwf INTCON	;Interrupts enabled GIEH y GIEL en 1
    clrf var_disp
    movff var_disp, TBLPTRL
    TBLRD*
    movff TABLAT, LATD    
    
loop:
    goto loop
    
TMR1_ISR:
    movlw 0x80	    
    movwf TMR1H
    movlw 0x00
    movwf TMR1L	    ;tejec = 6us
;    clrf TMR1L	    ;tejec = 7us cumpliendo que se suba la cta inicial antes de los 15.25us
    movlw .9
    cpfseq var_disp
    goto aunno
    clrf var_disp
    goto final
aunno:
    incf var_disp, f
final:
    movff var_disp, TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf PIR1, TMR1IF
    retfie
    
INT1_ISR:
    btg T1CON, TMR1ON
    bcf INTCON3, INT1IF
    retfie
    end