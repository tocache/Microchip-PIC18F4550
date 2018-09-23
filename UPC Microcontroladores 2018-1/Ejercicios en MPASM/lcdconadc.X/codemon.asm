    list p=18f4550
    #include "p18f4550.inc"
    #include "Digbyte.inc"

    CONFIG  FOSC = XT_XT    
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))    
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
 
    cblock 0x0060
	Dig0
	Dig1
	Dig2
	Digtemp
	contador
	endc
 
    org 0x1000
tabloton: da "Cuenta: "
 
    org 0x000
    goto camote
	
    org 0x020
camote:
    clrf TRISD
    call DELAY15MSEG
    call LCD_CONFIG
    movlw UPPER tabloton
    movwf TBLPTRU
    movlw HIGH  tabloton
    movwf TBLPTRH
    movlw LOW  tabloton
    movwf TBLPTRL
    call CURSOR_OFF
    clrf contador

inicio2:
    TBLRD*+
    movf TABLAT,W
    call  ENVIA_CHAR
    movlw .8
    cpfseq TBLPTRL
    goto  inicio2
final:
    movlw .8
    call  POS_CUR_FIL1
    digbyte contador
    movf Dig2, W
    addlw 0x30
    call  ENVIA_CHAR
    movf Dig1, W
    addlw 0x30
    call  ENVIA_CHAR
    movf Dig0, W
    addlw 0x30
    call  ENVIA_CHAR
    incf contador, f
    goto final
    
    #include "LCD_LIB.asm"
    end