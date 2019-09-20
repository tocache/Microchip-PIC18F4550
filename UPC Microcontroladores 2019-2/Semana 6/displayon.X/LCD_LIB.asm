RS   EQU  0
RW   EQU  1
E    EQU  2

 CBLOCK 0x000
    aux
    cont
    BCD2
    BCD1
    BCD0
    var
    dato
    rx
    aux1
    aux2
    aux3
    conta1
    conta2
    dir_CGRAM
    dir_CARACTER
    ENDC

    ORG 0x600

POS_CUR_FIL2:
	addlw 0xC0;
	movwf dato,0;
	call ENVIA_LCD_CMD
	return

POS_CUR_FIL1:
	addlw 0x80;
	movwf dato,0;
	call ENVIA_LCD_CMD
	return

DISPLAY_ON:
	movlw b'00001111'
	movwf dato,0;
	call ENVIA_LCD_CMD
	return

DISPLAY_OFF:
	movlw b'00001000'
	movwf dato,0;
	call ENVIA_LCD_CMD
	return

CURSOR_HOME:
	movlw b'00000010'
	movwf dato,0;
	call ENVIA_LCD_CMD
	return

CURSOR_OFF:
	movlw b'00001100'
	movwf dato,0;
	call ENVIA_LCD_CMD
	return

CURSOR_ON:
	movlw b'00001111'
	movwf dato,0;
	call ENVIA_LCD_CMD
	return

ENVIA_CHAR:
	movwf dato,0
	call ENVIA_LCD_DATO
	return

BORRAR_LCD:
	movlw 0x01
	movwf dato,0
	call ENVIA_LCD_CMD
	return

LCD_CONFIG:
	bcf   LATD,RS
	bcf   LATD,RW
	movlw 0x30
	call  ENVIA_NIBBLE
	call  DELAY2MSEG
	call  DELAY2MSEG
	call  DELAY2MSEG
	movlw 0x20
	call ENVIA_NIBBLE
	movlw 0x01
	call ENVIA_LCD_CMD;
	movlw 0x28		;Control del display (Activar,mostrar cursor y que parpadee)
	call ENVIA_LCD_CMD 
 	movlw 0x0F    ;Conjunto de inicio (Incrementar posici?n sin desplazamiento)
	call ENVIA_LCD_CMD  
	movlw 0x06    
	call ENVIA_LCD_CMD  
	movlw 0x01		;Limpiar el display;
	call ENVIA_LCD_CMD	
	return

ENVIA_NIBBLE:
	movwf rx,0
	movlw 0x0F
	andwf LATD,f,0
	movlw 0xF0
	andwf rx,W
	movf  rx,W,0
	iorwf LATD,f,0
	bsf   LATD,E,0
	bcf   LATD,E,0
	nop
	return

ENVIA_LCD_CMD:
	bcf LATD,RS,0
	movwf dato
	call DELAY2MSEG
	call DELAY2MSEG
	call DELAY2MSEG
	movlw b'00001000'
	movwf TRISD,0
	call DELAY100uS
	bcf  LATD,RW
	bcf  LATD,E
	bcf  LATD,RS
	movf dato,W,0
	andlw 0xF0;
	call ENVIA_NIBBLE
	swapf dato,f,0
	movf dato,W,0
	andlw 0xF0
	call ENVIA_NIBBLE
	return

ENVIA_LCD_DATO:
	bsf  LATD,RS
	movwf dato
	call DELAY2MSEG
	call DELAY2MSEG
	call DELAY2MSEG
	movlw b'00001000'
	movwf TRISD,0
	call DELAY100uS
	bcf  LATD,RW
	bcf  LATD,E
	bsf  LATD,RS
	movf dato,0,0
	andlw 0xF0;
	call ENVIA_NIBBLE
	swapf dato,f,0
	movf  dato,0,0
	andlw 0xF0
	call ENVIA_NIBBLE
	return

GENERA_CHAR_CGRAM:
	movlw 0x40
	addwf dir_CGRAM,W
	movwf dato
	call ENVIA_LCD_CMD
REPITE:
	TBLRD*+;
	movf  TABLAT,W
	movwf var
	movlw 0xFF
	subwf var,W
	btfsc STATUS,Z
	goto  SALIR
	movff var,dato
	call ENVIA_LCD_DATO
	goto  REPITE
SALIR:
	movlw 0x80
	movwf dato
	call ENVIA_LCD_CMD
	return	

DELAY2MSEG:
	movlw .7
	movwf conta1,0
RETAR1:
	movlw .100          ;1 useg
	movwf conta2,0	    ;1 useg
RETAR2:
	decfsz conta2,f,0	;1 useg
	goto   RETAR2		;2 useg
	decfsz conta1,f,0	;1 useg
	goto   RETAR1
	return

DELAY15MSEG:
	movlw .50
	movwf conta1,0
RETAR3:
	movlw .100
	movwf conta2,0
RETAR4:
	decfsz conta2,f,0
	goto   RETAR4
	decfsz conta1,f,0
	goto   RETAR3
	return

DELAY100uS:
	movlw .3
	movwf  conta1,0
RETAR7:
	movlw .9
	movwf conta2,0
RETAR8:
	decfsz conta2,f,0
	goto  RETAR8
	decfsz conta1,f,0
	goto  RETAR7
	return

BIN_BCD:
	movwf aux,0		;Se guarda el valor a convertir en aux
	clrf  cont,0	;cont=0x00
	clrf  BCD0,0	;BCD0=0x00
	clrf  BCD1,0    ;BCD1=0x00
	clrf  BCD2,0	;BCD2=0x00
CONV:
	rlcf  aux,f	    ;Rotar a la izquierda cont (cifra original)
	rlcf  BCD0,f	;Rotar a la izquierda BCD0 (carga el carry de cont en el bit LSB)
	rlcf  BCD2,f    ;Rotar a la izquierda BCD2 (carga el carry de BCD0 en el bit LSB)
;Cargar el nibble alto de BCD0 a BCD2 y analizar	
	movf  BCD0,W	;W = BCD0
	movwf BCD1,0	;BCD1 = BCD0
	swapf BCD1,f	;Inversi?n de nibbles en BCD1
	movlw 0x0F		;W = 0x0F
	andwf BCD1,f	;BCD1 = BCD1 AND 0x0F
	andwf BCD0,f	;BCD0 = BCD0 AND 0x0F
;Se pregunta si ya se llegaron a rotar a la izquierda los 8 bits
	movlw .7		;W = .7
	cpfslt cont,0	;Salta si cont es menor a .7
	return			;Si cont = .7 retorna (FIN de la rutina)
;Averiguar si los nibbles de BCD0 y BCD1 son mayores que .4
	movlw .5		;W = .5
	subwf BCD0,W	;W = BCD0 - .5
	btfsc STATUS,C  ;Si BCD0>4 => Carry = 1
	call  SUMA3_BCD0;BCD0>4, hay que sumar 3
	movlw .5		;BCD0 <5, se comprueba BCD1
	subwf BCD1,W	;W = BCD1 - .5
	btfsc STATUS,C  ;Si BCD1>4 => Carry = 1
	call  SUMA3_BCD1;BCD1>4, hay que sumar 3 
	swapf BCD1,f    ;Inversi?n de nibbles en BCD1
	movf  BCD1,W	;W = BCD1
	iorwf BCD0		;BCD0 = BCD1 OR BCD0
	incf  cont,f,0  ;cont = cont + 1
	goto  CONV		;Se repite el proceso
SUMA3_BCD0:
	movlw .3		;W = .3
	addwf BCD0,f,0  ;BCD0 = BCD0 + .3
	return			;retorno del call
SUMA3_BCD1:
	movlw .3		;W = .3
	addwf BCD1,f,0  ;BCD1 = BCD1 + .3
	return			;retorno del call
 ;END