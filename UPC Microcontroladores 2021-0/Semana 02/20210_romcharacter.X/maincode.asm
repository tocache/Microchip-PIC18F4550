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
    var_i
    var_j
    var_k
    endc

;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0700
;		A     B     C     D     E     F     G     H     I     J     K     L     M     N     O     P     Q     R     S     T     U     V     W     X     Y     Z         
;direccion hex  700   701   702   703   704   705   706   707   708   709   70A   70B   70C   70D   70E   70F   710   711   712   713   714   715   716   717   718   719 
romcharacter db 0x5F, 0x7C, 0x58, 0x5E, 0x79, 0x71, 0x3D, 0x74, 0x11, 0x0D, 0x75, 0x38, 0x55, 0x54, 0x5C, 0x73, 0x67, 0x50, 0x2D, 0x78, 0x1C, 0x2A, 0x6A, 0x14, 0x6E, 0x1B    
 
 
    org 0x0300
minombre db 0X0A, 0X00, 0X0B, 0X14, 0X0D	;Las letras de mi nombre

    org 0x0000
    goto init_conf

    org 0x0020
init_conf:
    clrf TRISD
    movlw 0x03
    movwf TBLPTRH
    movlw 0x00
    movwf TBLPTRL	;TBLPTR apunta a 0x0300
    lfsr 0, 0x010       ;FSR0 apunta a 0x010
    TBLRD*
    movff TABLAT, INDF0
    incf TBLPTRL, f
    incf FSR0L, f
    TBLRD*
    movff TABLAT, INDF0
    incf TBLPTRL, f
    incf FSR0L, f
    TBLRD*
    movff TABLAT, INDF0
    incf TBLPTRL, f
    incf FSR0L, f
    TBLRD*
    movff TABLAT, INDF0
    incf TBLPTRL, f
    incf FSR0L, f
    TBLRD*
    movff TABLAT, INDF0    
        
loop:
    movlw 0x07
    movwf TBLPTRH
    movlw 0x00
    movwf TBLPTRL
    lfsr 0, 0x010
    movff INDF0, TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    call delaymon
    incf FSR0L, f
    movff INDF0, TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    call delaymon
    incf FSR0L, f
    movff INDF0, TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    call delaymon
    incf FSR0L, f
    movff INDF0, TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    call delaymon
    incf FSR0L, f
    movff INDF0, TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    call delaymon
    goto loop
    
;subrutina de retardo    
delaymon:    
    movlw .50
    movwf var_i
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i,f
    goto otro1
    return
bucle1:
    movlw .55
    movwf var_j
otro2:
    nop
    nop
    call bucle2		;Salto a subrutina
    decfsz var_j,f
    goto otro2
    return
bucle2:
    movlw .20
    movwf var_k
otro3:
    nop
    decfsz var_k,f
    goto otro3
    return       
    
    end