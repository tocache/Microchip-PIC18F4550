;Nuestro primer programa en Assembler
;Para los comentarios usamos ";"

    list p=18f4550
    #include <p18f4550.inc>

    ;Declaración de las directivas de pre-procesador ó
    ;bits de configuración
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000
    goto inicio
    
    org 0x0020
inicio:
    bcf TRISD, 0		;Puerto D0 como salida
    bsf TRISB, 0		;Puerto B0 como entrada
    btfss PORTB, 0		;Preguntamos a B0 si es uno
    goto falsa			;Viene aquí cuando es falso
    bcf LATD, 0			;Viene aquí cuando es cierto, RD0=0
    goto inicio			;Regresa a la etiqueta inicio
falsa:
    bsf LATD, 0			;RD0=1
    goto inicio
    end
    