    list p=18f4550
    #include "p18f4550.inc"
    #include "LCD_LIB.asm"
    
    CONFIG  FOSC = XT_XT;FRELOJ<=4MHz
    CONFIG  PWRT = ON;Retardo de tiempo después del reset
    CONFIG  BOR = OFF;VDD va de 2V-5.7V
    CONFIG  WDT = OFF;Perro guardián OFF
    CONFIG  PBADEN = OFF;Pines AD Puerto B digital
    CONFIG  MCLRE = ON;Reset externo está activo
    CONFIG  LVP = OFF;Desactivar modo de bajo voltaje

    org 0x1000
primeralinea da "Hola$"		    ;4 caracteres
    org 0x1100
segundalinea da " UPC SM MICRO$"    ;13 caracteres
 
    org 0x0000
    goto menson

    org 0x0020
menson:
    ;-----------------------------
    ;Configuracion inicial del LCD
    clrf TRISD
    call DELAY15MSEG
    call LCD_CONFIG
    call CURSOR_OFF
    call BORRAR_LCD
    call CURSOR_HOME
    ;-----------------------------
inicio:
imprimeprimeralinea:
    movlw LOW primeralinea
    movwf TBLPTRL
    movlw HIGH primeralinea
    movwf TBLPTRH
bucle1:
    TBLRD*+
    movf TABLAT, W
    call ENVIA_CHAR
    TBLRD*
    movlw 0x24
    cpfseq TABLAT
    goto bucle1
imprimesegundalinea:
    movlw .0
    call POS_CUR_FIL2		;Mover cursor a la segunda linea
    movlw LOW segundalinea
    movwf TBLPTRL
    movlw HIGH segundalinea
    movwf TBLPTRH
bucle2:
    TBLRD*+
    movf TABLAT, W
    call ENVIA_CHAR
    TBLRD*
    movlw 0x24
    cpfseq TABLAT
    goto bucle2
fin:goto fin    
    end

