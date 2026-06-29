;================================================================
; Инициализация экрана на HD44780
;
; АХТУНГ!!! Файл располагать в сегменте кода, в файле init!!!
;================================================================

;================================================================
; ПП инициализации LCD
;================================================================
lcd_init:

	in		tempreg,LCD_DATA_DDR
	sbr		tempreg,(1<<D4|1<<D5|1<<D6|1<<D7)

	out		LCD_DATA_DDR,tempreg

#ifdef	USE_LIGHT
	sbi		LCD_LIGHT_DDR,LIGHT_BIT
	rcall	lcd_backlight_on
#endif

	sbi		LCD_RS_DDR,RS_BIT
	sbi		LCD_E_DDR,E_BIT
	
	ClearE														// инициализация управляющих сигналов

	rcall	LCD_16ms_delay
	LCD_command_high_nibble		0x30

	rcall	LCD_5ms_delay
	LCD_command_high_nibble		0x30

	rcall	LCD_160us_delay
	LCD_command_high_nibble		0x20

	/*LCD_command					0x28*/

	LCD_CommandStringFlash	init_tab							// передаем команду

	ret

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; таблица инициализации
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
init_tab:
	.db		0x05,0x28,0x01,0x06,0x0C,0x80

#ifdef	USE_LIGHT
lcd_backlight_on:
	LightOn
	ldi		Zh,high(light_off_tmr_init)
	ldi		Zl,low(light_off_tmr_init)
	sts		light_off_timer,Zl
	sts		light_off_timer+1,Zh
	ret
#endif
