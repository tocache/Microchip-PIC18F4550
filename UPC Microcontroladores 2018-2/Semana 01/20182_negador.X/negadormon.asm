    list p=18f4550	;Para indicar el modelo del PIC
    #include<p18f4550.inc>  ;Para llamar a la librería de nombres de los registros del PIC

;Zona de los bits de configuración del PIC
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000		;Vector de RESET
    goto configuro
    
    org 0x0020		;Zona de usuario
configuro:
	    bsf TRISD, 0    ;Puerto RD0 como entrada
	    bsf TRISD, 1
	    bsf TRISD, 2
	    bsf TRISD, 3
	    bcf TRISB, 0    ;Puerto RB0 como salida
	    bcf TRISB, 1
	    bcf TRISB, 2
	    bcf TRISB, 3
	    	    
inicio:
    btfss PORTD, 0
    goto noes
    bcf LATB, 0
    goto parte2
noes:
    bsf LATB, 0

parte2:
    btfss PORTD, 1
    goto noes2
    bcf LATB, 1
    goto parte3
noes2:
    bsf LATB, 1    

parte3:
    btfss PORTD, 2
    goto noes3
    bcf LATB, 2
    goto parte4
noes3:
    bsf LATB, 2 

parte4:
    btfss PORTD, 3
    goto noes4
    bcf LATB, 3
    goto inicio
noes4:
    bsf LATB, 3
    goto inicio
    end