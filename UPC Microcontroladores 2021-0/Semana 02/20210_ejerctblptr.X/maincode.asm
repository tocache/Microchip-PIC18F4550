;Este es un comentario
    list p=18f4550
    #include <p18f4550.inc>	;libreria de nombre de los registros sfr
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
   
    org 0x0500		    ;Sector de almacenamiento de constantes
numeros db 0x04, 0xAF, 0xBE, 0x89    
    
    org 0x0000		    ;Vector de reset
    goto configuro
    
    org 0x0020		    ;Zona de programa de usuario
configuro:
    clrf TRISD		    ;Todo RD como salida
    movlw HIGH numeros
    movwf TBLPTRH
    movlw LOW numeros
    movwf TBLPTRL	    ;Carga de la dirección de apunte de TBLPTR (0x0500)
    
inicio:
    TBLRD*
    movff TABLAT, LATD
    nop
    movlw 0x03
    cpfseq TBLPTRL
    goto falso
verdadero:
    nop
    goto verdadero
    
falso:
    incf TBLPTRL, f
    goto inicio
    
    end