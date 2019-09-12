    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x020		 ;Bloque de variable para delaymon
	var1
	var2
	var3
	endc
	
letrasa EQU 0x028
	
    org 0x0200
liston db 0x00, 0x00, 0x00, 0x00, 0x6F, 0x5F, 0x7C, 0x6E, 0x00, 0x00, 0x00, 0x00, 0x55, 0xAA, 0xEE
 
    org 0x0000			    ;Vector de RESET
    goto mercado
    
    org 0x0008			    ;Vector de la enterropceon alta p
    goto enterropt
    
    org 0x0020			    ;Zona de programa de usuario
mercado:
    movlw 0x80
    movwf TRISD			;Puerto conectado al 7segmentos mux segmentos
    movlw 0x0F
    movwf TRISB			;Puerto conectado al 7segm mux habilitadores
    movlw HIGH liston
    movwf TBLPTRH
    movlw LOW liston
    movwf TBLPTRL		;Asignación de dirección al puntero de tabla
    clrf LATD
    setf LATB
    movlw 0xC8
    movwf T0CON			;Configurando el TMR0 para temporizacion de 50us
    movlw .206
    movwf TMR0L			;La cuenta inicial de Dan
    movlw 0xA0
    movwf INTCON		;Enciendo la interrupcion de TMR0
    clrf letrasa

compra:
    call delaymon
    incf letrasa, f
    movlw .8
    cpfseq letrasa
    goto compra
otro:
    call delaymon
    decfsz letrasa, f
    goto otro
    goto compra
    
enterropt:
    movf letrasa,W
    addwf TBLPTRL
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 4
    nop
    bsf LATB, 4
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 7
    nop
    bsf LATB, 7
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 6
    nop
    bsf LATB, 6
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 5
    nop
    bsf LATB, 5
    clrf TBLPTRL
    movlw .206
    movwf TMR0L
    bcf INTCON, TMR0IF
    retfie

delaymon:
    movlw .100
    movwf var1
otro1:
    call anid1
    decfsz var1, f
    goto otro1
    return
anid1:
    movlw .20
    movwf var2
otro2:
    call anid2
    decfsz var2, f
    goto otro2
    return
anid2:
    movlw .10
    movwf var3
otro3:
    nop
    decfsz var3, f
    goto otro3
    return     
    end





