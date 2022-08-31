;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT erretece,class=CODE,reloc=2,abs
    ORG 00000H		;Vector de reset
erretece:	goto configuracion
    
    ORG 00008H		;Vector de interrupcion
vector_hp:	goto TMR1_ISR	    ;(2us)
    
    ORG 00020H
configuracion:
    bcf TRISD, 0   ;RD0 como salida
;    movlw 07H
;    movwf T1CON	    ;Tmr1 ON, PSC 1:1, T13CKI (T1OSCEN=0) sin XTAL para Proteus
    movlw 0FH
    movwf T1CON    ;Tmr1 ON, PSC 1:1, XTAL32K (T1OSCEN=1) con cristal 32K

    bsf PIE1, 0		;Configurar bit a bit los registros
    bsf INTCON, 6
    bsf INTCON, 7
    
loop:
    nop
    goto loop

TMR1_ISR:
    movlw 0C0H				;(1us)
    movwf TMR1H    ;32768		;(1us)
    clrf TMR1L				;(1us)
    btg LATD, 0	    ;Basculando RD0
    bcf PIR1, 0	    ;Bajo bandera de desborte de Timer1
    retfie	    ;Retorno de donde salté
    
    end erretece
    


