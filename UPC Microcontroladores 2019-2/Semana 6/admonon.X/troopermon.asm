;Este es un comentario
;Programa desarrollado por Kalun Lau
;UPC Monterrico 14 de agosto del 2019
    
    list p=18f4550		    ;Modelo del microcontrolador
    #include <p18f4550.inc>	    ;Libreria de nombre de los registros
    #include "LCD_LIB.asm"
    
    ;Aqui deben de estar los bits de configuracion o directivas de preprocesador
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x030
    var1
    var2
    var3
    endc
    
    org 0x0900
caderon da "Hello WORLD"
 
    org 0x0000			    ;Vector de RESET
    goto confeg

    org 0x0020
confeg:
    ;Para configurar el ADC primero ADCON2, luego ADCON1 y finalmente ADCON0
    ;ADCON2: Tiempo de adquisicion y ADFM
    ;ADCON1: Configurar los puertos analógicos
    ;ADCON0: Configurar el ADC
    movlw 0x24
    movwf ADCON2			;8TAD, FOsc/4 y ADFM=0
    movlw 0x0E			;Habilitado solo AN0
    movwf ADCON1
    movlw 0x01			;Escojo AN0 y enciendo el ADC
    movwf ADCON0
    ;Rutina de configuracion del LCD
    clrf TRISD			;Puerto RD como salida
    call DELAY15MSEG
    call LCD_CONFIG
    call CURSOR_HOME		;Cursor arriba a la izquierda
    call CURSOR_OFF
    call BORRAR_LCD
    ;Apunte del puntero de tabla
    movlw LOW caderon
    movwf TBLPTRL
    movlw HIGH caderon
    movwf TBLPTRH
    
lcd_disp:
    clrf TBLPTRL
    movlw 0x22
    call ENVIA_CHAR	;Imprimir una comilla
cade:			;Rutina de impresion de cadena
    TBLRD*+
    movf TABLAT, W
    call ENVIA_CHAR
    movlw .11
    cpfseq TBLPTRL
    goto cade
    movlw 0x22
    call ENVIA_CHAR	;Imprimir una comilla
;fin:goto fin
    
lecturon:
    bsf ADCON0, 1
aunno:
    btfsc ADCON0, 1
    goto aunno
;    movff ADRESH, LATD
;    call CURSOR_HOME
;    call DELAY15MSEG    
    call POS_CUR_FIL2
    call DELAY15MSEG    
    movf ADRESH, W
    call BIN_BCD
    movf BCD2, W
    addlw 0x30
    call ENVIA_CHAR
    movf BCD1, W
    addlw 0x30
    call ENVIA_CHAR
    movf BCD0, W
    addlw 0x30
    call ENVIA_CHAR
    call delaymon
    goto lecturon
    
delaymon:
    movlw .10
    movwf var1
otro1:
    call anid1
    decfsz var1, f
    goto otro1
    return
anid1:
    movlw .10
    movwf var2
otro2:
    call anid2
    decfsz var2, f
    goto otro2
    return
anid2:
    movlw .10
    movwf var3
otro3:
    nop
    decfsz var3, f
    goto otro3
    return  
    end