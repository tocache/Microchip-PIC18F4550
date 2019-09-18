    list p=18f4550
    #include <p18f4550.inc>
    #include "LCD_LIB.asm"
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    cblock 0x020
	cuenta
    endc
    
    org 0x0000			;Vector de RESET
    goto inicion

    org 0x0200
cadena da "Lectura ADC"    
    
inicion:
    clrf TRISD			;Puerto donde se conectara el LCD
    ;Primero ADCON2, luego ADCON1 y finalmente ADCON0
    ;ADCON2: Tiempo de conversion y justificacion del resultado
    ;ADCON1: Seleccionar quienes son analogicos y quienes digitales
    ;ADCON0: Control del ADC
    movlw 0x24		;8TAD, FOsc/4 y just izq
    movwf ADCON2
    movlw 0x0E		;AN0 habilitado solamente
    movwf ADCON1	
    movlw 0x01		;Encendemos el ADC
    movwf ADCON0

lecturon:
    call DELAY15MSEG		;Rutina de la librería para configurar el LCD
    call LCD_CONFIG    
    call CURSOR_OFF
    movlw HIGH cadena
    movwf TBLPTRH
    movlw LOW cadena
    movwf TBLPTRL		;Apuntando el TBLPTR a cadena
    call CURSOR_HOME		;Cursor del LCD al inicio
visual:
    TBLRD*+
    movf TABLAT, W
    call ENVIA_CHAR
    movlw .11
    cpfseq TBLPTRL
    goto visual
otro:
    goto otro
    
;    bsf ADCON0, 1
;buclon:
;    btfsc ADCON0, 1
;    goto buclon
;    movff ADRESH, LATD
;    goto lecturon
    end
    