;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador
    #include <p18f4550.inc>		;Llamo a la librería de nombre de los regs
    #include "LCD_LIB.asm"
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = XT_XT	  ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    
    org 0x1000
nombre:	da  "Kalun Jose#" 
    org 0x2000
apelli:	da  "Lau Gan#"	
	
    org 0x0000
    goto configuro
    
    ;Según la librería el LCD esta conectado con el PIC: RS->RD0, RW->RD1, E->RD2, Datos->RD4-RD7
configuro:
    clrf TRISD			;Todo el puerto D como salida (LCD)
    call DELAY15MSEG		;Rutina de la librería para configurar el LCD
    call LCD_CONFIG    
    call CURSOR_ON

inicio: movlw UPPER nombre		;Apuntamos el TBLPTR a nombre
	movwf TBLPTRU
	movlw HIGH nombre
	movwf TBLPTRH
	movlw LOW nombre
	movwf TBLPTRL
otro:	TBLRD*+
        movf TABLAT,W
        call  ENVIA_CHAR
        movlw "#"
        cpfseq TABLAT
        goto otro
	call MOV_CUR_FIL2
	movlw UPPER apelli		;Apuntamos el TBLPTR a apelli
	movwf TBLPTRU
	movlw HIGH apelli
	movwf TBLPTRH
	movlw LOW apelli
	movwf TBLPTRL
otro2:	TBLRD*+
        movf TABLAT,W
        call  ENVIA_CHAR
        movlw "#"
        cpfseq TABLAT
        goto otro2	
	
fin:	nop
	goto fin
        end