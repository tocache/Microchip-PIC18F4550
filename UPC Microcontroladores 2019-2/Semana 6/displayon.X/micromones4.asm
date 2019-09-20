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

    cblock 0x50
	camote
    endc
    
    org 0x1000
primeralinea da "UPC SM MICRO$"		    ;4 caracteres
;alternativo db 'H','o','l','a','$' 
    org 0x1100
segundalinea da "Canal AN0: $"    ;13 caracteres
 
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
    ;Configuracion del ADC
    ;Configuracion del ADCON2 para el tiempo de conversion
    movlw 0x24
    movwf ADCON2	;8TAD FOSC/4 y justificacion izquierda
    ;Configuracion del ADCON1 para seleccionar los canales analog
    movlw 0x0E
    movwf ADCON1	;AN0 y sin VREF
    ;Configuracion del ADCON0 para seleccionar el canal a leer
    movlw 0x01
    movwf ADCON0
inicio:
    movlw .37
    movwf camote
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
lectura_adc:
    bsf ADCON0, 1	;Inicio una conversion en AN0
aunno:
    btfsc ADCON0, 1	;Pregunto si ya termino la conversion
    goto aunno
    movf ADRESH, W	;El resultado de la conversion lo mando a W
    call BIN_BCD	;Rutina que saca los digitos de un reg de 8bit
    movf BCD2, W	;Jalo la centena a W
    addlw 0x30		;Le sumo 0x30 para que sea un caracter numérico
    call ENVIA_CHAR	;Envio el caradcter al LCD
    movf BCD1, W	;Jalo la decena a W
    addlw 0x30		;Le sumo 0x30 para que sea un caracter numérico
    call ENVIA_CHAR	;Envio el caradcter al LCD
    movf BCD0, W	;Jalo la unidad a W
    addlw 0x30		;Le sumo 0x30 para que sea un caracter numérico
    call ENVIA_CHAR	;Envio el caradcter al LCD
    goto imprimesegundalinea
    end

