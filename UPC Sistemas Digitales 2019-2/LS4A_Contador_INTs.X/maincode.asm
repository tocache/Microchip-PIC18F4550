    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

cuenta equ 0x00
 
    org 0x0200
tabla7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0X7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
;Disp7seg:  0     1     2     3     4     5     6     7     8     9     E     E     E     E     E     E    
    
    org 0x0000
    goto config_p
    
    org 0x0020
config_p:   movlw 0x80
	    movwf TRISD		;Puertos RD6 al RD0 como salidas
	    movlw LOW tabla7s
	    movwf TBLPTRL
	    movlw HIGH tabla7s
	    movwf TBLPTRH
	    clrf cuenta
	    call disp_update

inicio:	    btfss PORTB, 0
	    goto no1
	    incf cuenta, f
	    call nooopsters
	    call disp_update
otro1:	    btfsc PORTB, 0
	    goto otro1
	    goto salida
no1:	    btfss PORTB, 1
	    call salida
	    decf cuenta, f
	    call nooopsters
	    call disp_update
otro2:	    btfsc PORTB, 1
	    goto otro2
salida:	    goto inicio
    
nooopsters: nop
	    nop
	    nop
	    nop
	    return
	    
disp_update:movf cuenta, W
	    movwf TBLPTRL
	    TBLRD*
	    movff TABLAT, LATD
	    return
	    
	    end
	    


