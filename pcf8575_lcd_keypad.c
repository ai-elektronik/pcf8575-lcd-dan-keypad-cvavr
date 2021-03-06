#include <mega328p.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <twi2.h>
#include <i2c_lcd.c>

unsigned char baca_keypad();

void main(void){
unsigned char buf[16];
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

twiinit();
lcd_begin();
gotoxy(0,0);
put("BY :");
gotoxy(0,1);
put("AI-ELEKTRONIK");
delay_ms(1000);
clear();
while (1){

buf[0]=baca_keypad();buf[1]='\0';
gotoxy(0,0);put(buf);
}
}

unsigned char baca_keypad(){
unsigned char key;
twistart();
twiwrite(0b01001110);
twiwrite(0x00);
twiwrite(0xf6);
twistop();

twistart();
twiwrite(0b01001111);
twiread(1);
key=twiread(0);
twistop();

if( ((key>>4)&1)==0)return '1';
if( ((key>>5)&1)==0)return '4';
if( ((key>>6)&1)==0)return '7';
if( ((key>>7)&1)==0)return '*';

twistart();
twiwrite(0b01001110);
twiwrite(0x00);
twiwrite(0xf5);
twistop();

twistart();
twiwrite(0b01001111);
twiread(1);
key=twiread(0);
twistop();

if( ((key>>4)&1)==0)return '2';
if( ((key>>5)&1)==0)return '5';
if( ((key>>6)&1)==0)return '8';
if( ((key>>7)&1)==0)return '0';

twistart();
twiwrite(0b01001110);
twiwrite(0x00);
twiwrite(0xf3);
twistop();

twistart();
twiwrite(0b01001111);
twiread(1);
key=twiread(0);
twistop();

if( ((key>>4)&1)==0)return '3';
if( ((key>>5)&1)==0)return '6';
if( ((key>>6)&1)==0)return '9';
if( ((key>>7)&1)==0)return '#';

return 'x';
}