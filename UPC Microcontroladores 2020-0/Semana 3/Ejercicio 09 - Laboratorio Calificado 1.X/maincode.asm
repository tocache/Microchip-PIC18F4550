    list p=18f4550		;Modelo del microcontrolador
    #include<p18f4550.inc>	;Libreria de nombre de registros
    
    ;Aquí van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x020
	var_i
	var_j
	var_k
	estado
	letra_actual
    endc    
    
    org 0x0600
mensaje db 0x00,0x00,0x00,0x00,0x37,0x06,0x39,0x50,0x3f,0x39,0x3f,0x54,0x78,0x50,0x3f,0x38,0x77,0x5e,0x3f,0x50,0x79,0x6d,0x00,0x00,0x00
    org 0x0000
    goto configuro
    org 0x0008
    goto hi_isr
    org 0x0018
    goto lo_isr
    org 0x0020
configuro:    
    clrf TRISD
    clrf TRISE
    bcf TRISB, 4
    bcf TRISB, 5
    bcf TRISB, 6
    bcf TRISB, 7
    movlw HIGH mensaje
    movwf TBLPTRH
    movlw LOW mensaje
    movwf TBLPTRL
    movlw .1
    movwf estado
    movlw 0xF0
    movwf LATB
    clrf letra_actual
    ;Configurar el Timer0
    movlw 0xC8
    movwf T0CON		    ;Timer0 ON modo 8bit PSC 1:1
    ;Configurar las interrupciones
    bsf RCON, IPEN
    bcf INTCON2, TMR0IP
    bsf INTCON, TMR0IE
    ;bcf INTCON2, INTEDG0
    ;bcf INTCON2, INTEDG1
    ;bcf INTCON2, INTEDG2
    bsf INTCON, INT0IE
    bsf INTCON3, INT1IE
    bsf INTCON3, INT2IE
    bsf INTCON, GIEL
    bsf INTCON, GIEH
    
inicio:
    movlw .1
    cpfseq estado
    goto segundaprueba
    goto elprimero
segundaprueba:
    movlw .2
    cpfseq estado
    goto terceraprueba
    goto elsegundo
terceraprueba:
    movlw .3
    cpfseq estado
    goto inicio
    goto eltercero
    
elprimero:
    movlw .24
    cpfseq letra_actual
    goto aunno1
    clrf letra_actual
    call retardo_500ms
    clrf estado
    goto inicio
aunno1:
    incf letra_actual, f
    call retardo_500ms
    goto elprimero
elsegundo:
    movlw .24
    cpfseq letra_actual
    goto aunno2
    clrf letra_actual
    call retardo_500ms
    goto parte2
aunno2:
    incf letra_actual, f
    call retardo_500ms
    goto elsegundo
parte2:    
    movlw .24
    cpfseq letra_actual
    goto aunno3
    clrf letra_actual
    call retardo_500ms
    clrf estado
    goto inicio
aunno3:
    incf letra_actual, f
    call retardo_500ms
    goto elsegundo

eltercero:
    movlw .24
    movwf letra_actual
bucle:
    movlw .0
    cpfseq letra_actual
    goto nopues
    call retardo_500ms
    clrf estado
    goto inicio
nopues:
    decf letra_actual, f
    call retardo_500ms    
    goto bucle
    
hi_isr:
    ;Establezco que INT0, INT1 e INT2 son de alta prioridad
    btfss INTCON, INT0IF
    goto albtn2
    goto btn1
albtn2:
    btfss INTCON3, INT1IF
    goto btn3
    goto btn2
btn1:
    movlw .1
    movwf estado
    bsf LATE,0
    bcf INTCON, INT0IF
    retfie
btn2:
    movlw .2
    movwf estado
    bsf LATE,1    
    bcf INTCON3, INT1IF
    retfie
btn3:
    movlw .3
    movwf estado
    bsf LATE,2    
    bcf INTCON3, INT2IF
    retfie

lo_isr:    
    ;Establezco que TMR0 es de baja prioridad (usado para el refresco)
    movf letra_actual, W
    movwf TBLPTRL
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 4
    call noops
    bsf LATB, 4
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 5
    call noops
    bsf LATB, 5
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 6
    call noops
    bsf LATB, 6
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 7
    call noops
    bsf LATB, 7
    bcf INTCON, TMR0IF
    retfie

noops:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    return
    
retardo_500ms:
    clrf var_i
otro1:
    call anid_1
    movlw .9
    cpfseq var_i
    goto falso1
    return
falso1:
    incf var_i,f
    goto otro1
    
anid_1:
    clrf var_j
otro2:
    call anid_2
    movlw .10
    cpfseq var_j
    goto falso2
    return
falso2:
    incf var_j, f
    goto otro2

anid_2:
    clrf var_k
otro3:
    nop
    nop
    movlw .109
    cpfseq var_k
    goto falso3
    return
falso3:
    incf var_k, f
    goto otro3
    end





