    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = OFF           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x020		 ;Bloque de variable para delaymon
	var1
	var2
	var3
	endc

letramon EQU 0x60		;Indice de cambio de visualizacion	
	
    org 0x0400
tablaton db 0x00, 0x00, 0x00, 0x3F, 0x06, 0x5B, 0x00, 0x00, 0x00, 0x55, 0xAA
 
    org 0x0000
    goto confeg		;Vector de RESET
    
    org 0x0008
    goto enterropt	;Vector de Interrupción (desborde de TMR0)
    
    org 0x0020
confeg:
    movlw 0x80
    movwf TRISD		;Configurando los puertos como salida
    movlw 0x1F
    movwf TRISB
    movlw HIGH tablaton
    movwf TBLPTRH
    movlw LOW tablaton
    movwf TBLPTRL	;Asignando la dirección 0x0400 al punto de tabla
    clrf LATD
    setf LATB
    movlw 0xC8
    movwf T0CON		;Activamos y configuramos el Timer0 1:1, FOsc/4
    movlw 0xA0
    movwf INTCON	;Activamos la interrupción por desborde de TMR0
    movlw .206
    movwf TMR0L		;Temporización de 100us en el TMR0
    clrf letramon

lazaso:
    call delaymon
    incf letramon, f
    movlw .7
    cpfseq letramon
    goto lazaso
    clrf letramon
    goto lazaso

enterropt:    
    movf letramon, W
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 7
    nop
    bsf LATB, 7
    movf letramon, W
    addlw .1
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 6
    nop
    bsf LATB, 6    
    movf letramon, W
    addlw .2
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 5
    nop
    bsf LATB, 5
    movlw .206
    movwf TMR0L		;Temporización de 100us en el TMR0
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


