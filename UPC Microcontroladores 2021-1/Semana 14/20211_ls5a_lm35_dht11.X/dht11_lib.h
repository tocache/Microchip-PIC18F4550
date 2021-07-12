#ifndef XC_HEADER_TEMPLATE_H
#define	XC_HEADER_TEMPLATE_H

#include <xc.h> // include processor files - each processor file is guarded.  

#define _XTAL_FREQ 48000000UL

void DHT11_Start(void);
void DHT11_Check(void);
unsigned char DHT11_Read(void);

#endif	/* XC_HEADER_TEMPLATE_H */

