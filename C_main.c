#include "stm32f10x.h"                  // Device header
char zaman[7];
uint32_t sayim=0;
void Delays(int time) /// Random delay function
{
	int t;
	for(;time>0;time--)
	{
	 for(t=0;t<20;t++)
		{}
	}
}

void int2char(int num, char str[])
{
  char lstr[30];
   int cnt = 0;
  int div = 10;
  int j = 0;

	
	
  while( num >= div)
 {
	lstr[cnt] = num % div + 0x30;
	num /= 10;
	cnt++;
 }
	lstr[cnt] = num + 0x30;
  for(j= cnt ; j >=0;j--)
 {
	str[cnt-j] = lstr[j];
 }
   
   
}


void lcd_cmd(unsigned char data)
{
	//pin_output(0,11);
	GPIOA->ODR &=~0x100;//lcd_rs(LOW);
	GPIOA->ODR &=~0x200;//lcd_rw(LOW);
	Delays(10);
	GPIOA->ODR |=0x400;//lcd_e(HIGH);
	Delays(5);
	GPIOA->ODR &= 0xff0f;
	GPIOA->ODR |= (data & 0x00f0);
	Delays(10);
	GPIOA->ODR &=~0x400;//lcd_e(LOW);
	
	Delays(20);
	
	GPIOA->ODR |=0x400;//lcd_e(HIGH);
	Delays(5);
	GPIOA->ODR &= 0xff0f;
	GPIOA->ODR |= ((data << 4) & 0x00f0);
	Delays(10);
	GPIOA->ODR &=~0x400;//lcd_e(LOW);
}

void lcd_msg(unsigned char line_1_2, unsigned char pos_0_16, char msg[])
{
	short pos = 0;
	if(line_1_2==1)
	{
		pos = 0;
	}
	else if(line_1_2==2)
	{
		pos = 0x40;
	}
	lcd_cmd(0x80 +pos + pos_0_16);
	Delays(100);
	int i = 0;
		while(msg[i])
		{		
				//pin_output(4,7);
	    GPIOA->ODR |=0x100;//lcd_rs(HIGH);
	    GPIOA->ODR &=~0x200;//lcd_rw(LOW);
	    Delays(10);
	    GPIOA->ODR |=0x400;//lcd_e(HIGH);
	    Delays(5);
	    GPIOA->ODR &= 0xff0f;
	    GPIOA->ODR |= (msg[i] & 0x00f0);
	    Delays(10);
	    GPIOA->ODR &=~0x400;//lcd_e(LOW);
	
	    Delays(20);
	
	    GPIOA->ODR |=0x400;//lcd_e(HIGH)
	    Delays(5);
	    GPIOA->ODR &= 0xff0f;
	    GPIOA->ODR |= ((msg[i] << 4) & 0x00f0);
	    Delays(10);
	    GPIOA->ODR &=~0x400;//lcd_e(LOW)
			i++;
			Delays(100);
		}
}

int main(void)
{	
	//pin_output(4,11);

	RCC->APB2ENR = 0x04; /// port a aktif
	GPIOA->CRL   = 0x33330000; /// pin 3 ü çikis olarak ayarla
	GPIOA->CRH   = 0x00003333; /// pin 3 ü çikis olarak ayarla
	
	Delays(10000);
	
	GPIOA->ODR &=~0x100;//lcd_rs(LOW);
	GPIOA->ODR &=~0x200;//lcd_rw(LOW)=;
	Delays(10);
	GPIOA->ODR |=0x400;//lcd_e(HIGH);
	Delays(5);
	GPIOA->ODR &= 0xff0f;
	GPIOA->ODR |= 0x20; // 4 bit communication mode 
	Delays(10);
	GPIOA->ODR &=~0x400;//lcd_e(LOW);
	
	
	lcd_cmd(0x2C); // 4 bit communication mode / 2 lines
	Delays(5000);
	lcd_cmd(0x0C); // Display ON
	Delays(5000);
	lcd_cmd(0x01); // Clear Display
	Delays(5000);
	lcd_cmd(0x02); // Get back to initial address
	Delays(5000);
	
		lcd_msg(1, 0,"Gecen zaman");
		
	while(1)
	{
		Delays(500000);
		sayim++;
		int2char(sayim,zaman);
		lcd_msg(2, 2,zaman);
	}
	
}

