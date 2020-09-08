;Este es un comentario
    PROCESSOR 18F4550
    #include <xc.inc>
    
;Declaramos los bits de configuración del proecsador
    CONFIG CONFIG1L = 00h
    CONFIG CONFIG1H = 05h
    CONFIG CONFIG2L = 1Fh
    CONFIG CONFIG2H = 1Fh
    CONFIG CONFIG3H = 83h
    CONFIG CONFIG4L = 85h
    CONFIG CONFIG5L = 0Fh
    CONFIG CONFIG5H = 0C0h
    CONFIG CONFIG6L = 0Fh
    CONFIG CONFIG6H = 0E0h
    CONFIG CONFIG7L = 0Fh
    CONFIG CONFIG7H = 40h
    
    CONFIG CONFIG2L.BOR = OFF
    CONFIG BOREN0 = 1

    org 0x0000		
    goto configu
    
    org 0x0020
configu: nop
    end





