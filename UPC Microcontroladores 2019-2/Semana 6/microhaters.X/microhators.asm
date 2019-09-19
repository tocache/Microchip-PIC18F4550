    list p=18f4550
    #include "p18f4550.inc"
    #include "LCD_LIB.asm"
    
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
    CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x1000
cadena1 da "Hello uc-lovers "
 
    org 0x1100
cadena2 da "AN0: "    
    
    org 0x0000
    goto haters
    
    org 0x0020
haters:    
    ;Configuracion del ADC
    ;Primero configuramos ADCON2 (tiempo de adquisicion y justificacion del resultado)
    movlw 0x24
    movwf ADCON2
    ;Segundo configuramos ADCON1 (que puertos van a ser analogicos)
    movlw 0x0E
    movwf ADCON1
    ;Tercero configuramos ADCON0 (que canal vamos a leer y activacion del AD)
    movlw 0x01
    movwf ADCON0
    ;Configuracion inicial del LCD
    clrf TRISD
    call DELAY15MSEG
    call LCD_CONFIG		    ;Para que el bus de comunicacion sea de 4bits
    call CURSOR_OFF
    call BORRAR_LCD
    call CURSOR_HOME
visfirstline:			    ;Apuntamos el TBLPTR hacia cadena1
    movlw LOW cadena1
    movwf TBLPTRL
    movlw HIGH cadena1
    movwf TBLPTRH
bucle1:
    TBLRD*+			    ;Obtenemos un caracter de la cadena1
    movf TABLAT, W
    call ENVIA_CHAR		    ;Mandamos el caracter hacia el LCD
    movlw .15
    cpfseq TBLPTRL		    ;Preguntamos si llegamos al final de la cadena1
    goto bucle1
vissecndline:
    movlw LOW cadena2
    movwf TBLPTRL
    movlw HIGH cadena2
    movwf TBLPTRH
    movlw .0
    call POS_CUR_FIL2
bucle2:
    TBLRD*+
    movf TABLAT, W
    call ENVIA_CHAR
    movlw .4
    cpfseq TBLPTRL
    goto bucle2
lecturaadc:
    bsf ADCON0, 1		    ;Iniciamos la conversion AD en AN0
aunno:
    btfsc ADCON0, 1		    ;Preguntamos si termino de convertir
    goto aunno
    movf ADRESH, W
    call BIN_BCD		    ;Convertimos el resultado en digitos individuales
    movf BCD2, W
    addlw 0x30
    call ENVIA_CHAR
    movf BCD1, W
    addlw 0x30
    call ENVIA_CHAR
    movf BCD0, W
    addlw 0x30
    call ENVIA_CHAR
    goto vissecndline
;fin:goto fin
    end
