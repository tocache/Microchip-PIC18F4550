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
    movlw 'c'
    call ENVIA_CHAR
    movlw 'a'
    call ENVIA_CHAR
    movlw 0xEE
    call ENVIA_CHAR
    movlw 'o'
    call ENVIA_CHAR
fin:goto fin
    end

