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
	
    org 0x0500
mensajon db 0x00, 0x00, 0x3E, 0x73, 0x39, 0x32, 0x15, 0xAA, 0x50, 0x44, 0x7E, 0x2B, 0x00, 0x80	;0x80 es el fin de cadena
 
    org 0x0000
    goto confeg
    
    org 0x0020
confeg:
    movlw 0x80
    movwf TRISD			;Puertos RD(6:0) como salidas
    movwf TRISB			;Puertos RB(6:0) como salidasd
    movlw LOW mensajon
    movwf TBLPTRL
    movlw HIGH mensajon
    movwf TBLPTRH		;Puntero de tabla apunta a 0x0500
prelooper:
    clrf TBLPTRL		;Nos ubicamos en 0x0500
looper:
    TBLRD*+			;Leo lo que apunta TBLPTR e incremento la dirección de apunte
    movff TABLAT, LATB
    TBLRD*+
    movff TABLAT, LATD
    call delaymon
    TBLRD*
    movlw 0x80
    cpfseq TABLAT
    goto falso
    goto prelooper
falso:    
    decf TBLPTRL, f
    goto looper

delaymon:
    movlw .100
    movwf var1
otro1:
    call anid1
    decfsz var1, f
    goto otro1
    return
anid1:
    movlw .50
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