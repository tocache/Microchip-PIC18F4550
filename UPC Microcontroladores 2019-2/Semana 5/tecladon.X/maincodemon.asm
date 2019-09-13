    list p=18f4550
    #include "p18f4550.inc"
    
    CONFIG  FOSC = XT_XT;FRELOJ<=4MHz
    CONFIG  PWRT = ON;Retardo de tiempo después del reset
    CONFIG  BOR = OFF;VDD va de 2V-5.7V
    CONFIG  WDT = OFF;Perro guardián OFF
    CONFIG  PBADEN = OFF;Pines AD Puerto B digital
    CONFIG  MCLRE = ON;Reset externo está activo
    CONFIG  LVP = OFF;Desactivar modo de bajo voltaje
 
    cblock 0x020
	col_1
	col_2
	col_3
	col_4
	tecla
	endc

    org 0x0400
decod7s db 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x67    
 
    org 0x0000
    goto MAIN

    org 0x020
MAIN:
    movlw HIGH decod7s
    movwf TBLPTRH
    movlw LOW decod7s
    movwf TBLPTRL
    movlw 0x80
    movwf TRISD		;RD como salidas para el display
    movlw 0xF0
    movwf TRISB		;RB(3:0) como salidas
    bcf INTCON2, RBPU	;Activo las resistencias de pullup de RB
    setf LATB		
    
looper:
    movlw 0x0E
    movwf LATB
    movf PORTB, W
    movwf col_1
    movlw 0x0D
    movwf LATB
    movf PORTB, W
    movwf col_2
    movlw 0x0B
    movwf LATB
    movf PORTB, W
    movwf col_3
    movlw 0x07
    movwf LATB
    movf PORTB, W
    movwf col_4
    call formateador
    movff tecla, TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    goto looper

formateador:
    btfss col_1, 4
    goto uno
    btfss col_1, 5
    goto dos
    btfss col_1, 6
    goto tres
    btfss col_1, 7
    goto cuatro
    btfss col_2, 4
    goto cinco
    btfss col_2, 5
    goto seis
    btfss col_2, 6
    goto siete
    btfss col_2, 7
    goto ocho
    btfss col_3, 4
    goto nueve
    btfss col_3, 5
    goto diez
    btfss col_3, 6
    goto once
    btfss col_3, 7
    goto doce
    btfss col_4, 4
    goto trece
    btfss col_4, 5
    goto catorce
    btfss col_4, 6
    goto quince
    btfss col_4, 7
    goto dieciseis
    clrf LATD
    return

uno:	movlw 0x01
	movwf tecla
	return
dos:	movlw 0x02
	movwf tecla
	return
tres:	movlw 0x03
	movwf tecla
	return
cuatro: movlw 0x04
	movwf tecla
	return
cinco:	movlw 0x05
	movwf tecla
	return
seis:	movlw 0x06
	movwf tecla
	return
siete:	movlw 0x07
	movwf tecla
	return
ocho:	movlw 0x08
	movwf tecla
	return
nueve:	movlw 0x09
	movwf tecla
	return
diez:	movlw 0x0A
	movwf tecla
	return
once:	movlw 0x0B
	movwf tecla
	return
doce:	movlw 0x0C
	movwf tecla
	return
trece:	movlw 0x0D
	movwf tecla
	return
catorce:movlw 0x0E
	movwf tecla
	return
quince:	movlw 0x0F
	movwf tecla
	return
dieciseis:
	movlw 0x00
	movwf tecla
	return
    end
    
    

