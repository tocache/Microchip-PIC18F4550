#ifndef XC_DHT11_H
#define	XC_DHT11_H

#include <xc.h> // include processor files - each processor file is guarded.  
#define _XTAL_FREQ 48000000UL

void DHT11_Start(void);
void DHT11_Check(void);
unsigned char DHT11_Read(void);

#endif	/* XC_DHT11 */

