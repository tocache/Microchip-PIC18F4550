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
	
    org 0x0400
tablaton db 0x00, 0x00, 0x00, 0x3F, 0x06, 0x5B, 0x00, 0x00, 0x00, 0x55, 0xAA
 
    org 0x0000
    goto confeg
    
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
    
previaso:
    movlw 0x03
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 7
    call delaymon
    bsf LATB, 7
    movlw 0x04
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 6
    call delaymon
    bsf LATB, 6    
    movlw 0x05
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB, 5
    call delaymon
    bsf LATB, 5
    goto previaso

;Subrutina de retardo de 3 anillos    
delaymon:
    movlw .10
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
    
    
    