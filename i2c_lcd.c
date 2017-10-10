#define lcdw 0b01001110
#define lcdr 0b01001111

#define en   0b00000100
#define rw   0b00000010
#define rs   0b00000001
#define backon 0x08
#define backoff 0x00

//unsigned char kolom_lcd=16;
unsigned char baris_lcd=2;
//unsigned char charsize=0;
unsigned char display_control;
unsigned char display_mode;

void expander_write(unsigned char data){
twistart();
twiwrite(lcdw);
twiwrite(data | backon);
twiwrite(0xff);
twistop();
}

void pulse_enable(unsigned char data){
expander_write(data | en);
delay_us(1);
expander_write(data & ~en);
delay_us(50);
}

void write4bits(unsigned char data){
expander_write(data);
pulse_enable(data);
}

void send(unsigned char data,unsigned char mode){
unsigned char high=data&0xf0;
unsigned char low=(data<<4)&0xf0;
write4bits((high)|mode);
write4bits((low)|mode);
}

void command(unsigned char data){
send(data,0);
}

void write(char data){
send(data,rs);
}

void clear(){
command(0x01); //lcd clear display command
delay_ms(2);
}

void display(){
    display_control|=0x04;//lcd display on
    command(0x08 | display_control); //0x08=lcd display control
}

void home(){
    command(0x02); // lcd kembali ke posisi 0,0
    delay_ms(2);
}

void gotoxy(unsigned char x,unsigned char y){
    int row_offsets[]={0x00,0x40,0x14,0x54};
    if(y>baris_lcd)y=baris_lcd-1;
    command(0x80|(x+row_offsets[y])); //0x80 = alamat ddram lcd
}

void lcd_begin(){
//4 bit mode ,  lcd 1 line , lcd 5x8 per karakter
unsigned char displayfunction = 0x00 | 0x00 | 0x00;
if(baris_lcd>1)displayfunction |= 0x08; //2 line lcd

delay_ms(50);

expander_write(backon);
delay_ms(1000);

write4bits(0x03<<4);
delay_us(4500);
write4bits(0x03<<4);
delay_us(4500);
write4bits(0x03<<4);
delay_us(150);
write4bits(0x02 << 4);
command(0x20|displayfunction); //0x20 lcd function set

// lcd display on, lcd cursor off, lcd blink off
display_control= 0x04 | 0x00 | 0x00;
display();

clear();

//lcd entryleft , lcd entry decrement
display_mode=0x02|0x00;
command(0x04|display_mode); //0x04 = lcd entry modeset

home();
}

void put(char *teks){
char k;
while (k=*teks++)write(k);
}

