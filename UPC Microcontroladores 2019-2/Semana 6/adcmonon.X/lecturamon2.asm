    list p=18f4550
    #include<p18f4550.inc>
    #include "LCD_LIB.asm"
    
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    cblock 0x030		 ;Bloque de variable para delaymon
	var1
	var2
	var3
	endc
	
    org 0x1000
cadenita da "Micromon 2019-2"

    org 0x0000
    goto meme
    
    org 0x0020
meme:
    ;Configuracion del LCD
    clrf TRISD			;Conexion al LCD
    call DELAY15MSEG
    call LCD_CONFIG
    call BORRAR_LCD
    call CURSOR_OFF
    call CURSOR_HOME
visual:
    movlw LOW cadenita
    movwf TBLPTRL
    movlw HIGH cadenita
    movwf TBLPTRH
    movlw 0x22
    call ENVIA_CHAR
bucle:
    TBLRD*+
    movf TABLAT, W  
    call ENVIA_CHAR
    movlw .15
    cpfseq TBLPTRL
    goto bucle
    movlw 0x22
    call ENVIA_CHAR
fin:call DISPLAY_ON
    call CURSOR_OFF
    call delaymon
    call DISPLAY_OFF
    call delaymon
    goto fin    
    
delaymon:
    movlw .100
    movwf var1
otro1:
    call anid1
    decfsz var1, f
    goto otro1
    return
anid1:
    movlw .100
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
    


