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
mensajon db 0x3E, 0x73, 0x39, 0x00
 
    org 0x0000
    goto confeg
    
    org 0x0020
confeg:
    movlw 0x80
    movwf TRISD			;Puertos RD(6:0) como salidas
    movlw LOW mensajon
    movwf TBLPTRL
    movlw HIGH mensajon
    movwf TBLPTRH		;Puntero de tabla apunta a 0x0500

looper:
    TBLRD*+			;Lectura de lo apuntado por TBLPTR e incremento de la posicion
    movff TABLAT, LATD		;Muevo el contenido de TABLAT hacia RD
    call delaymon		;Retardo entre cambio de letras
    movlw .4			;El numero de letras del mensaje
    cpfseq TBLPTRL
    goto looper
    clrf TBLPTRL
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
    movlw .100
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