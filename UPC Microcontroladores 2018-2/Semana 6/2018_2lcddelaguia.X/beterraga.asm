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
    CONFIG LVP = OFF

contador EQU 0x30
 
    ORG 0x0000
    goto MAIN
    
    ORG 0x7000

MENSAJE: da "Hola UPC Yo soy electronico"
    ORG 0x0020
MAIN:
    clrf TRISD
    call DELAY15MSEG
    call LCD_CONFIG
    clrf TRISB
    setf LATB
    call CURSOR_ON
    movlw HIGH MENSAJE
    movwf TBLPTRH
    movlw LOW MENSAJE
    movwf TBLPTRL
    clrf contador
INICIO:
    movlw .3
    call POS_CUR_FIL1
ENVIANDO:
    TBLRD*
    movf TABLAT,W
    call ENVIA_CHAR
    incf TBLPTRL
    movlw .8
    cpfseq TBLPTRL
    goto ENVIANDO
    movlw .0
    call POS_CUR_FIL2
ENVIANDO2:
    TBLRD*
    movf TABLAT,W
    call ENVIA_CHAR
    incf TBLPTRL
    movlw .27
    cpfseq TBLPTRL
    goto ENVIANDO2
FIN:
    goto FIN

    #include "LCD_LIB.asm"
    
    END
