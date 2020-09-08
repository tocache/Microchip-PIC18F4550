;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuración
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

cuenta EQU 0x030	;La posicion 0x030 de la memoria de datos se llamara cuenta
    
    org 0x0000		;Vector de RESET
    goto init_conf
 
    org 0x0700
datos db 0x55, 0xAA    
    
    org 0x0020		;Zona de programa de usuario
init_conf:
    clrf TRISD		;Por acá saldrán los datos que se obtengas del TBLPTR
    ;Vamos a colocarle la dirección inicial de TBLPTR
    movlw HIGH datos
    movwf TBLPTRH
    movlw LOW datos
    movwf TBLPTRL	;Aquí el punto YA SE ENCUENTRA APUNTANDO A 0x0150
    clrf cuenta		;Forzamos al registro GPR que sea cero
    
loop:
    btfss PORTB, 0	;Preguntamos si se presiono boton0
    goto next1
    goto accion1
next1:
    btfss PORTB, 1	;Preguntamos si se presiono boton1
    goto next2
    goto accion2
next2:
    btfss PORTB, 2	;Preguntamos si se presionó boton2
    goto loop
    goto accion3
    
accion1:
    movlw 0x00
    movwf TBLPTRL	;Para acceder a 0x0700 de la mem prog
    TBLRD*
    movff TABLAT, LATD
    incf cuenta, f	;Incremento la cuenta y se almacena en el registro
otro1:
    btfsc PORTB, 0
    goto otro1
    goto loop

accion2:
    movlw 0x01
    movwf TBLPTRL	;Para acceder a 0x0700 de la mem prog
    TBLRD*
    movff TABLAT, LATD
    incf cuenta, f	;Incremento la cuenta y se almacena en el registro
otro2:
    btfsc PORTB, 1
    goto otro2
    goto loop 
    
accion3:
    lfsr 0, 0x030	;Asignación una dirección de memoria de datos a FSR0
    movff INDF0, LATD
otro3:
    btfsc PORTB, 2
    goto otro3
    goto loop
    end
    