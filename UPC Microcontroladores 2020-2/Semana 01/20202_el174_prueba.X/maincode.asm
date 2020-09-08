;Este es un comentario
    PROCESSOR 18F4550
    #include <xc.inc>
    
;Declaramos los bits de configuración del proecsador
    CONFIG FOSC = XT_XT        ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA4/OSC2/CLKOUT and RA5/OSC1/CLKINT)
    CONFIG WDT = OFF       ; Watchdog Timer Enable bit (WDT disabled)
    CONFIG PWRT = ON       ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG MCLRE = ON       ; MCLR Pin Function Select bit (MCLR pin function is MCLR)
    ;CONFIG CP0 = OFF         ; Code Protection bit (Program memory code protection is disabled)
    ;CONFIG CPD = OFF        ; Data Code Protection bit (Data memory code protection is disabled)
    CONFIG BOR = OFF
    CONFIG IESO = ON        ; Internal External Switchover bit (Internal External Switchover mode is enabled)
    CONFIG FCMEN = ON       ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)    

analog EQU 0x023
	
    org 0x0000		
    goto configu
    
    org 0x0020
configu: nop
    end


