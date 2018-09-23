    #include "p18f4550.inc"

    CONFIG FOSC = XT_XT
    CONFIG PWRT = ON 
    CONFIG BOR = OFF
    CONFIG BORV = 3
    CONFIG VREGEN = OFF
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG MCLRE = ON
    ;Falta el siguiente bit de configuración en la guía
    ;CONFIG LVP = OFF

    ORG 0x0000
    goto MAIN
    
    ORG 0x7000
MENSAJE: da "Estado de RE.0:"
    ORG 0x7100
apagao:	da "Apagado  "
    ORG 0x7200	
encend:	da "Encendido"	
	
    ORG 0x0020
MAIN:
    clrf TRISD
    call DELAY15MSEG
    call LCD_CONFIG
    clrf TRISB
    setf LATB
    movlw 0x0F
    movwf ADCON1	    ;Para hacer que los puertos RE sean digitales
    bsf TRISE, 0
    call CURSOR_OFF
INICIO:
    movlw HIGH MENSAJE
    movwf TBLPTRH
    movlw LOW MENSAJE
    movwf TBLPTRL
    movlw .0
    call POS_CUR_FIL1
ENVIANDO:
    TBLRD*
    movf TABLAT,W
    call ENVIA_CHAR
    incf TBLPTRL
    movlw .15
    cpfseq TBLPTRL
    goto ENVIANDO

ENVIANDO2:
    movlw .0
    call POS_CUR_FIL2
    btfss PORTE, 0
    goto cero
    goto uno
cero:
    movlw HIGH apagao
    movwf TBLPTRH
    movlw LOW apagao
    movwf TBLPTRL
otro1:
    TBLRD*
    movf TABLAT,W
    call ENVIA_CHAR
    incf TBLPTRL
    movlw .9
    cpfseq TBLPTRL
    goto otro1
    goto ENVIANDO2
uno:
    movlw HIGH encend
    movwf TBLPTRH
    movlw LOW encend
    movwf TBLPTRL
otro2:
    TBLRD*
    movf TABLAT,W
    call ENVIA_CHAR
    incf TBLPTRL
    movlw .9
    cpfseq TBLPTRL
    goto otro2
    goto ENVIANDO2
    
FIN:
    goto FIN

    #include "LCD_LIB.asm"
    
    END
