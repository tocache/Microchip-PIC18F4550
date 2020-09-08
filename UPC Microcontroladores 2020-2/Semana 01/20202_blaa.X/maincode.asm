    list p=18f4550	    ;modelo del microcontrolador
    #include<p18f4550.inc>  ;libreria de nombre de los registros
    
    ;aqui declaramos los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000		    ;Vector de RESET
    goto configuro	    ;salto a etiqueta configuro
    
    org 0x0020		    ;zona de programa de usuario
configuro:
    bsf TRISB, 0	    ;pin RB0 como entrada
    bcf TRISD, 0	    ;pin RD0 como salida
    
principal:		    ;programa principal
    btfss PORTB, 0	    ;preguntamos si se presiono BTN
    goto principal	    ;no se presiono BTN y saltamos a principal
    btg LATD, 0		    ;se presiono BTN y se complementa RD0
otro:
    btfsc PORTB, 0	    ;preguntamos si se solto BTN
    goto otro		    ;no se solto BTN
    goto principal	    ;se solto el BTN y saltamos a principal
    
    end			    ;fin del codigo