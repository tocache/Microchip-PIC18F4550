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

    
    ;Lo de lineas se almacenara de manera secuencial desde la 0x0300 en la mem prog
    org 0x0400
tabla_7s db 0xBF, 0x86, 0xDB, 0xCF, 0xE6, 0xED, 0xFD, 0x87, 0xFF, 0xE7    
    
;Aqu� va el cblock o declaaraci�n de nombres de GPR    
    cblock 0x000
	cta
    endc
    
    org 0x0000
    goto init_conf
    
    org 0x0008
    goto TMR1_ISR

;Aqu� se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    clrf TRISD	    ;RD como salidas para manejar el display
    movlw 0x07
    movwf T1CON
    movlw 0xC0	    ;GIE=1 y PEIE=1
    movwf INTCON
    movlw 0x01
    movwf PIE1	    ;TMR1IE=1
    movlw HIGH tabla_7s
    movwf TBLPTRH
    movlw LOW tabla_7s
    movwf TBLPTRL	;TBLPTR apuntando a 0x0400

loop:
    movf cta, W
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    goto loop
    
TMR1_ISR:
    movlw 0xF0
    movwf TMR1H
    clrf TMR1L	    ;Carga cuenta inicial en TMR1
    movlw .9
    cpfseq cta
    goto noescierto
    clrf cta
    goto otro
noescierto:
    incf cta, F
otro:
    bcf PIR1, TMR1IF
    retfie
    end