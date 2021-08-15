			         EXPORT Ana_Program
Delay_suresi         EQU  0x109A95;8mhz/3(clock sinyali)=2.333.333=0x239A95
RCC                  EQU  0x40021000 ;RCC nin adresi
GPIOA_CRL	         EQU  0x40010800 ;Port c nin adresi
GPIOA_ODR	         EQU  0x4001080C	
RCC_APBENR           EQU  0x40021000	
DelayUs10            EQU  0x08000229
RCC_APB2ENR          EQU  0x40021018	
DelayInit            EQU  0x33330000
SysTickVal           EQU  0x08000335
DelayUs20000         EQU  0x62616872
RCC_CR               EQU  0x40021000
RCC_CFGR             EQU  0x40021000
FLASH_ACR            EQU  0x40022000
Ram_adres            EQU  0x20000500
;........................................................
;PA8 -> RS
;PA9 -> RW
;PA10-> E
;PA4 -> DB4
;PA5 -> DB5
;PA6 -> DB6
;PA7 -> DB7
;..........................................................

				     AREA Bolum3, CODE, READONLY							   							   

;.......................Delays..........................
     ;6:         for(;time>0;time--) 
     ;7:         { 
Delay_fonksiyonu     B        forr
     ;8:          for(t=0;t<20;t++) 
     ;9:                 {} 
    ;10:         } 
sayy                 MOVS     r1,#0x02
ekle                 ADDS     r1,r1,#1
                     CMP      r1,#0x2  ;0x14
                     BLT      ekle
                     SUBS     r0,r0,#1
     ;6:         for(;time>0;time--) 
     ;7:         { 
     ;8:          for(t=0;t<20;t++) 
     ;9:                 {} 
    ;10:         } 
forr                 CMP      r0,#0x00
                     BGT      sayy
    ;11: } 
    ;12:  
    ;13: void lcd_cmd(unsigned char data) 
    ;14: { 
    ;15:         //pin_output(0,11); 
                     BX       lr
   ;988: { 
;.......................Delays..........................







;.......................LCD_CMD..........................
    ;16:         GPIOA->ODR &=~0x100;//lcd_rs(LOW); 
lcd_cmd              LDR      r2,=GPIOA_ODR  ; @0x080003B0
    ;14: { 
    ;15:         //pin_output(0,11); 
					 PUSH     {lr}
                     MOV      r3,r0
    ;16:         GPIOA->ODR &=~0x100;//lcd_rs(LOW); 
                     LDR      r0,[r2,#0x00]
                     BIC      r0,r0,#0x100
                     STR      r0,[r2,#0x00]
    ;17:         GPIOA->ODR &=~0x200;//lcd_rw(LOW); 
                     LDR      r0,[r2,#0x00]
                     BIC      r0,r0,#0x200
                     STR      r0,[r2,#0x00]				 
    ;18:         Delays(10); 
                     MOVS     r0,#0x0A
                     BL     Delay_fonksiyonu 
    ;19:         GPIOA->ODR |=0x400;//lcd_e(HIGH); 
                     LDR      r0,[r2,#0x00]
                     ORR      r0,r0,#0x400
                     STR      r0,[r2,#0x00]
    ;20:         Delays(5); 
                     MOVS     r0,#0x05
                     BL     Delay_fonksiyonu 
    ;21:         GPIOA->ODR &= 0xff0f; 
                     LDR      r0,[r2,#0x00]
                     MOVW     r4,#0xFF0F
                     ANDS     r0,r0,r4
                     STR      r0,[r2,#0x00]
    ;22:         GPIOA->ODR |= (data & 0x00f0); 
                     LDR      r0,[r2,#0x00]
                     AND      r1,r3,#0xF0
                     ORRS     r0,r0,r1
                     STR      r0,[r2,#0x00]
    ;23:         Delays(10); 
                     MOVS     r0,#0x0A
                     BL     Delay_fonksiyonu
    ;24:         GPIOA->ODR &=~0x400;//lcd_e(LOW); 
    ;25:          
                     LDR      r0,[r2,#0x00]
                     BIC      r0,r0,#0x400
                     STR      r0,[r2,#0x00]
    ;26:         Delays(20); 
    ;27:          
                     MOVS     r0,#0x14
                     BL     Delay_fonksiyonu 
    ;28:         GPIOA->ODR |=0x400;//lcd_e(HIGH); 
                     LDR      r0,[r2,#0x00]
                     ORR      r0,r0,#0x400
                     STR      r0,[r2,#0x00]
    ;29:         Delays(5); 
                     MOVS     r0,#0x05
                     BL     Delay_fonksiyonu 
    ;30:         GPIOA->ODR &= 0xff0f; 
                     LDR      r0,[r2,#0x00]
                     ANDS     r0,r0,r4
                     STR      r0,[r2,#0x00]
    ;31:         GPIOA->ODR |= ((data << 4) & 0x00f0); 
                     LDR      r0,[r2,#0x00]
                     LSLS     r1,r3,#28
                     ORR      r0,r0,r1,LSR #24
                     STR      r0,[r2,#0x00]
    ;32:         Delays(10); 
                     MOVS     r0,#0x0A
                     BL     Delay_fonksiyonu 
    ;33:         GPIOA->ODR &=~0x400;//lcd_e(LOW); 
                     LDR      r0,[r2,#0x00]
                     BIC      r0,r0,#0x400
                     STR      r0,[r2,#0x00]
					 POP      {lr}
                     BX       lr					 
;.......................LCD_CMD..........................


	
;.......................LCD_MSG.......................... 	
lcd_msg              
     ;36: void lcd_msg(unsigned char line_1_2, unsigned char pos_0_16, char msg[]) 
;0x080003AE BD10      POP      {r4,pc}
;0x080003B0 080C      DCW      0x080C
;0x080003B2 4001      DCW      0x4001
    ;37: { 
	                 

                     PUSH     {lr};link register(geri donme adresi) stacke kaydet
                     MOV      r5,r2
    ;38:         short pos = 0; 
                     MOVS     r2,#0x00
    ;39:         if(line_1_2==1) 
   ; 40:         { 
    ;41:                 pos = 0; 
    ;42:         } 
                     CMP      r0,#0x01
                     BEQ      msgg
    ;43:         else if(line_1_2==2) 
    ;44:         { 
                     CMP      r0,#0x02
                     BNE      msgg
    ;45:                 pos = 0x40; 
    ;46:         } 
                     MOVS     r2,#0x40
    ;47:         lcd_cmd(0x80 +pos + pos_0_16); 
msgg                 ADDS     r0,r2,r1
                     ADDS     r0,r0,#0x80
                     UXTB     r0,r0            ;--------------------------------------------------->8 BIT DEGER DÖNDÜRÜR
                     BL       lcd_cmd 
    ;48:         Delays(100); 
                     MOVS     r0,#0x64
                     BL       Delay_fonksiyonu 
    ;49:         int i = 0; 
                     MOVS     r4,#0x00
    ;50:                 while(msg[i]) 
    ;51:                 {               
    ;52:                                 //pin_output(4,7); 
                     B        ileri
    ;53:             GPIOA->ODR |=0x100;//lcd_rs(HIGH); 
gerii                LDR      r3,=GPIOA_ODR  ; @0x08000468
                     LDR      r0,[r3,#0x00]
                     ORR      r0,r0,#0x100
                     STR      r0,[r3,#0x00]
    ;54:             GPIOA->ODR &=~0x200;//lcd_rw(LOW); 
                     LDR      r0,[r3,#0x00]
                     BIC      r0,r0,#0x200
                     STR      r0,[r3,#0x00]
    ;55:             Delays(10); 
                     MOVS     r0,#0x0A
                     BL       Delay_fonksiyonu 
    ;56:             GPIOA->ODR |=0x400;//lcd_e(HIGH); 
                     LDR      r0,[r3,#0x00]
                     ORR      r0,r0,#0x400
                     STR      r0,[r3,#0x00]
    ;57:             Delays(5); 
                     MOVS     r0,#0x05
                     BL       Delay_fonksiyonu 
    ;58:             GPIOA->ODR &= 0xff0f; 
                     LDR      r0,[r3,#0x00]
                     MOVW     r2,#0xFF0F
                     ANDS     r0,r0,r2
                     STR      r0,[r3,#0x00]
    ;59:             GPIOA->ODR |= (msg[i] & 0x00f0); 
                     LDR      r0,[r3,#0x00]
                     LDRB     r1,[r5,r4]
                     AND      r1,r1,#0xF0
                     ORRS     r0,r0,r1
                     STR      r0,[r3,#0x00]
    ;60:             Delays(10); 
                     MOVS     r0,#0x0A
                     BL       Delay_fonksiyonu 
    ;61:             GPIOA->ODR &=~0x400;//lcd_e(LOW); 
    ;62:          
                     LDR      r0,[r3,#0x00]
                     BIC      r0,r0,#0x400
                     STR      r0,[r3,#0x00]
    ;63:             Delays(20); 
    ;64:          
                     MOVS     r0,#0x14
                     BL       Delay_fonksiyonu 
    ;65:             GPIOA->ODR |=0x400;//lcd_e(HIGH) 
                     LDR      r0,[r3,#0x00]
                     ORR      r0,r0,#0x400
                     STR      r0,[r3,#0x00]
    ;66:             Delays(5); 
                     MOVS     r0,#0x05
                     BL       Delay_fonksiyonu 
    ;67:             GPIOA->ODR &= 0xff0f; 
                     LDR      r0,[r3,#0x00]
                     ANDS     r0,r0,r2
                     STR      r0,[r3,#0x00]
    ;68:             GPIOA->ODR |= ((msg[i] << 4) & 0x00f0); 
                     LDR      r0,[r3,#0x00]
                     LDRB     r1,[r5,r4]
                     LSLS     r1,r1,#28
                     ORR      r0,r0,r1,LSR #24
                     STR      r0,[r3,#0x00]
    ;69:             Delays(10); 
                     MOVS     r0,#0x0A
                     BL       Delay_fonksiyonu 
    ;70:             GPIOA->ODR &=~0x400;//lcd_e(LOW) 
    ;71:                         i++; 
                     LDR      r0,[r3,#0x00]
                     BIC      r0,r0,#0x400
                     STR      r0,[r3,#0x00]
    ;72:                         Delays(100); 
    ;73:                 } 
                     MOVS     r0,#0x64
                     ADDS     r4,r4,#1
                     BL       Delay_fonksiyonu 
    ;50:                 while(msg[i]) 
    ;51:                 {               
    ;52:                                 //pin_output(4,7); 
    ;53:             GPIOA->ODR |=0x100;//lcd_rs(HIGH); 
    ;54:             GPIOA->ODR &=~0x200;//lcd_rw(LOW); 
    ;56:             GPIOA->ODR |=0x400;//lcd_e(HIGH); 
    ;57:             Delays(5); 
    ;58:             GPIOA->ODR &= 0xff0f; 
    ;59:             GPIOA->ODR |= (msg[i] & 0x00f0); 
    ;;60:             Delays(10); 
    ;61:             GPIOA->ODR &=~0x400;//lcd_e(LOW); 
    ;62:          
    ;63:             Delays(20); 
    ;64:          
    ;65:             GPIOA->ODR |=0x400;//lcd_e(HIGH) 
    ;66:             Delays(5); 
    ;67:             GPIOA->ODR &= 0xff0f; 
    ;68:             GPIOA->ODR |= ((msg[i] << 4) & 0x00f0); 
    ;69:             Delays(10); 
    ;70:             GPIOA->ODR &=~0x400;//lcd_e(LOW) 
    ;71:                         i++; 
    ;72:                         Delays(100); 
    ;73:                 } 
ileri                LDRB     r0,[r5,r4]
                     CMP      r0,#0x00
                     BNE      gerii
    ;74: } 
    ;75:  
    ;76: int main(void) 
    ;77: {        
    ;78:         //pin_output(4,11); 
				     POP      {lr};geri dönüs adresini stackden geri al
                     BX       lr

;.......................LCD_MSG.........................					 
					 


;.......................int2char..........................

    ;15: { 
    ;16:   char lstr[30]; 
int2char                                 
    ;17:    int cnt = 0; 
	                 PUSH     {lr}
                     MOVS     r2,#0x00
                     SUB      sp,sp,#0x20
    ;18:   int div = 10; 
    ;19:   int j = 0; 
    ;20:  
    ;21:          
    ;22:          
    ;23:   while( num >= div) 
    ;24:  { 
                     MOVS     r4,#0x0A
    ;16:   char lstr[30]; 
    ;17:    int cnt = 0; 
    ;18:   int div = 10; 
    ;19:   int j = 0; 
    ;20:  
    ;21:          
    ;22:          
    ;23:   while( num >= div) 
    ;24:  { 
                     MOV      r3,sp
                     MOV      r6,r4
                     B        whilee
    ;25:         lstr[cnt] = num % div + 0x30; 
                     NOP      
cntt                 SDIV     r5,r0,r4;bölümden kalan
                     MLS      r5,r4,r5,r0;Sonucun en az anlamli 32 bitini veren, isaretli veya isaretsiz 32-bit islenenlerle Çarp-Çikar.
    ;26:         num /= 10; 
    ;27:         cnt++; 
    ;28:  } 
                     SDIV     r0,r0,r6
                     ADDS     r5,r5,#0x30
                     STRB     r5,[r3,r2]
                     ADDS     r2,r2,#1
    ;23:   while( num >= div) 
    ;24:  { 
    ;25:         lstr[cnt] = num % div + 0x30; 
    ;26:         num /= 10; 
    ;27:         cnt++; 
    ;28:  } 
whilee               CMP      r0,r4
                     BGE      cntt
                     ADDS     r0,r0,#0x30
    ;29:         lstr[cnt] = num + 0x30; 
                     STRB     r0,[r3,r2]
    ;30:   for(j= cnt ; j >=0;j--) 
    ;31:  { 
                     MOVS     r0,r2
                     BMI      lstrr
    ;32:         str[cnt-j] = lstr[j]; 
    ;33:  } 
    ;34:     
    ;35:     
forrr                LDRB     r4,[r3,r0]
                     SUBS     r5,r2,r0
                     SUBS     r0,r0,#1
                     STRB     r4,[r1,r5]
                     BPL      forrr
    ;36: }
lstrr                ADD      sp,sp,#0x20
                    ; POP      {r4-r6}	
					 POP      {lr}
                     BX       lr
;.......................int2char..........................








Ana_Program
;........................MAIN...........................
                     LDR      r5,=0x20000000
	;94:         RCC->APB2ENR = 0x04; /// port a aktif 
                     MOV      r0,#0x04
                     LDR      r1,=RCC_APBENR  
                     STR      r0,[r1,#0x18]
    ;95:         GPIOA->CRL   = 0x33330000; /// pin 3 ü çikis olarak ayarla 
                     LDR      r0,=0x33330000
                     LDR      r1,=GPIOA_CRL  
                     STR      r0,[r1,#0x00]
   ; 96:         GPIOA->CRH   = 0x00003333; /// pin 3 ü çikis olarak ayarla 
                     MOV      r0,#0x00003333 
                     STR      r0,[r1,#0x04]
   ;108:         Delays(10000); 
   ;109:      



                     MOVW     r0,#0x2710
                     BL       Delay_fonksiyonu 
    ;85:         GPIOA->ODR &=~0x100;//lcd_rs(LOW); 
                     LDR      r2,=GPIOA_CRL  ; @0x08000520
                     ADDS     r2,r2,#0x0C
                     LDR      r0,[r2,#0x00]
                     BIC      r0,r0,#0x100
                     STR      r0,[r2,#0x00]
    ;86:         GPIOA->ODR &=~0x200;//lcd_rw(LOW); 
                     LDR      r0,[r2,#0x00]
                     BIC      r0,r0,#0x200
                     STR      r0,[r2,#0x00]
    ;87:         Delays(10); 
                     MOVS     r0,#0x0A
                     BL       Delay_fonksiyonu 
    ;88:         GPIOA->ODR |=0x400;//lcd_e(HIGH); 
                     LDR      r0,[r2,#0x00]
                     ORR      r0,r0,#0x400
                     STR      r0,[r2,#0x00]
    ;89:         Delays(5); 
                     MOVS     r0,#0x05
                     BL       Delay_fonksiyonu 
    ;90:         GPIOA->ODR &= 0xff0f; 
                     LDR      r0,[r2,#0x00]
                     MOVW     r1,#0xFF0F
                     ANDS     r0,r0,r1
                     STR      r0,[r2,#0x00]
    ;91:         GPIOA->ODR |= 0x20; // 4 bit communication mode  
                     LDR      r0,[r2,#0x00]
                     ORR      r0,r0,#0x20
                     STR      r0,[r2,#0x00]
    ;92:         Delays(10); 
                     MOVS     r0,#0x0A
                     BL       Delay_fonksiyonu 
    ;93:         GPIOA->ODR &=~0x400;//lcd_e(LOW); 
    ;94:          
    ;95:          
                     LDR      r0,[r2,#0x00]
                     BIC      r0,r0,#0x400
                     STR      r0,[r2,#0x00]
   ;121:         lcd_cmd(0x2C); // 4 bit communication mode / 2 lines 
                     MOVS     r0,#0x2C
                     BL       lcd_cmd 
   ;122:         Delays(5000); 
                     MOVW     r4,#0x1388
                     MOV      r0,r4
                     BL       Delay_fonksiyonu 
   ;123:         lcd_cmd(0x0C); // Display ON 
                     MOVS     r0,#0x0C
                     BL       lcd_cmd  
   ;124:         Delays(5000); 
                     MOV      r0,r4
                     BL       Delay_fonksiyonu 
   ;125:         lcd_cmd(0x01); // Clear Display 
                     MOVS     r0,#0x01
                     BL       lcd_cmd  
   ;126:         Delays(5000); 
                     MOV      r0,r4
                     BL       Delay_fonksiyonu 
   ;127:         lcd_cmd(0x02); // Get back to initial address 
                     MOVS     r0,#0x02
                     BL       lcd_cmd  
   ;128:         Delays(5000); 
   ;129:          
                     MOV      r0,r4
                     BL       Delay_fonksiyonu 

                     MOV      r10,#0
                     LDR      r11,=Ram_adres
                     STR      r10,[r11];seçilen ram adresini sifirla 


                     ADDS     r11,r11,#0x4
                     STR      r10,[r11]	;seçilen ram adresini sifirla
					 
   ;130:                 lcd_msg(1, 0,"Gecen zaman"); 
                     ADRL     r2,yazi   
                     MOVS     r1,#0x00
                     MOVS     r0,#0x01
                     BL       lcd_msg



   ;132:         while(1)
                   					 
      
   ;135:                 Delays(500000); 
while                LDR      r5,=0xF4240
   ;136:                   sayim++; 				 
                     LDR      r4,=Ram_adres				 
                     MOV      r0,r5
                     BL       Delay_fonksiyonu
                     LDR      r0,[r4,#0x00]
   ;137:                 int2char(sayim,zaman); 
                     
                     LDR      r1,=Ram_adres	
                     ADDS     r0,r0,#1
                     ADDS     r1,r1,#4
                     STR      r0,[r4,#0x00]
                     BL       int2char			;desimal sayinin ascii karsiligini bulan fonksiyon		 

  ; 138:                 lcd_msg(2, 2,zaman);
                     LDR      r2,=Ram_adres
                     MOVS     r1,#0x02 
                     ADDS     r2,r2,#4					 
                     MOV      r0,r1
					 BL       lcd_msg
                     


                    
                     B        while	

yazi			     DCW      0x6547;Ge
                     DCW      0x6563;ce
                     DCW      0x206E;n
                     DCW      0x617A;za
                     DCW      0x616D;ma
                     DCW      0x006E;n
					 					
                     ALIGN
							   
				     END
