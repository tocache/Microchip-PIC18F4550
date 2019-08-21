    list p=18f4550	    ;modelo de microcontrolador
    #include<p18f4550.inc>  ;llamada a la libreria de nombres
    
;Aqui van los bits de configuracion (directivas de pre procesador)
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    CONFIG  MCLRE = ON
    
   
    
    org 0x0000		    ;vector de RESET
    goto inicio
    
    org 0x0020		    ;Inicio del area de programa de usuario
inicio:
    movlw 0xFC
    movwf TRISD		    ;Puertos RD0 y RD1 como salidas
    movlw 0x03
    movwf TRISB		    ;Puertos RB0 y RB1 como entradas, NO ES NECESARIO!
    call modo0		    ;Modo inicial MODO0
looper:
    btfss PORTB, 0	    ;Preguntamos si se presiono BTN1
    goto pregbtn2_a	    ;Salta aqui si es falso y salta a rutina de pregunta de BTN2
    call modo1
lp2:
    btfsc PORTB, 0
    goto pregbtn2_b
lp3:    
    btfss PORTB, 0
    goto pregbtn2_c
    call modo2
lp4:
    btfsc PORTB, 0
    goto pregbtn2_d
lp5:
    btfss PORTB, 0
    goto pregbtn2_e
    call modo0
lp6:
    btfsc PORTB, 0
    goto pregbtn2_f
    goto looper
    
pregbtn2_a:
    btfss PORTB, 1
    goto looper
    goto sibtn2

pregbtn2_b:
    btfss PORTB, 1
    goto lp2
    goto sibtn2
pregbtn2_c:
    btfss PORTB, 1
    goto lp3
    goto sibtn2
pregbtn2_d:
    btfss PORTB, 1
    goto lp4
    goto sibtn2
pregbtn2_e:
    btfss PORTB, 1
    goto lp5
    goto sibtn2
pregbtn2_f:
    btfss PORTB, 1
    goto lp6
    goto sibtn2
    
sibtn2:
    call modo0
otro:
    btfsc PORTB, 1
    goto otro
    goto looper
    
modo0:
    movlw 0x00
    movwf LATD
    return

modo1:
    movlw 0x03
    movwf LATD
    return

modo2:
    movlw 0x02
    movwf LATD
    return
    
    end
    