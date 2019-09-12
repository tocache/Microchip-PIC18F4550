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

posicion EQU 0x030
 
    org 0x0200
flamita db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3C,0x42,0x99,0xBD,0x42,0x24
flamita2 db 0x24,0x18,0x00,0x24,0x4A,0xD3,0x91,0x89,0xDB,0x76,0x18,0x00,0x3C,0x42
flamita3 db 0x99,0xBD,0x42,0x24,0x24,0x18,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    org 0x0300
foquito db 0x3C,0x42,0x99,0xBD,0x42,0x24,0x24,0x18
 
    org 0x0000			;Vector de RESET
    goto confego
    
    org 0x0008			;Vector de INTERUPCION ALTA
    goto enterrop
    
    org 0x0020
confego:
    clrf TRISB			;Puertos como salida RB y RD
    clrf TRISD
    movlw HIGH flamita		;Asignando una dirección al TBLPTR
    movwf TBLPTRH
    movlw LOW flamita
    movwf TBLPTRL
    setf LATD			;Condicion inicial de las columnas (apagadas)
    movlw 0xC8
    movwf T0CON			;Timer0 con FOSC/4, PSC 1:1
    movlw .176
    movwf TMR0L			;Cuenta inicial del TMR0
    movlw 0xA0
    movwf INTCON		;Habilitamos interrupciones para el TMR0
    
inicio:
    clrf posicion
bucle:
    call delaymon
    incf posicion, f
    movlw .32
    cpfseq posicion		;Preguntamos si posicion=16
    goto otraso
bucl2:
    call delaymon
    decfsz posicion, f
    goto otraso2
    goto inicio

otraso:
    movlw .17
    cpfseq posicion
    goto bucle
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    goto bucle

otraso2:
    movlw .17
    cpfseq posicion
    goto bucl2
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    call delaymon
    goto bucl2
    
enterrop:    
    movf posicion, W
    movwf TBLPTRL
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
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 4
    nop
    bsf LATB, 4
    TBLRD*+
    movff TABLAT, LATD		;33us
    bcf LATB, 3
    nop
    bsf LATB, 3
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 2
    nop
    bsf LATB, 2
    TBLRD*+
    movff TABLAT, LATD
    bcf LATB, 1
    nop
    bsf LATB, 1
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 0
    nop
    bsf LATB, 0
    bcf INTCON, TMR0IF		;Bajamos la bandera de desborde de TMR0
    movlw .176
    movwf TMR0L			;Precargamos cuenta en TMR0
    retfie			;59us

delaymon:
    movlw .100
    movwf var1
otro1:
    call anid1
    decfsz var1, f
    goto otro1
    return
anid1:
    movlw .10
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
    
    
    

