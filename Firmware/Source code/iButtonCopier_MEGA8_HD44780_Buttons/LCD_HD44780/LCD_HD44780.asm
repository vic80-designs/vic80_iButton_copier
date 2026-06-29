// ==================================================================================
// Библиотека функций для работы с контроллером LCD дисплеев HD44780
// 
// АХТУНГ!!! Файл располагать в сегменте кода, после файла с дефайнами!!!
//
// для работы необходиме временные регистры tempreg, tempreg1
// Работает при частоте процессора: 1-16 МГЦ
// ==================================================================================

;================================================================
; Запись строки в LCD из памяти данных (на входе - в рег. Z
; адрес начала строки. Строка должна заканчиваться кодом 0х00)
;================================================================
/*RAM_to_lcd:
	ld		tempreg,Z+
	tst		tempreg
	breq	end_RAM_to_lcd
	rcall	lcd_write_byte
	rjmp	RAM_to_lcd
end_RAM_to_lcd:
	ret*/

;================================================================
; Запись строки в LCD из памяти программ (на входе - в рег. Z
; адрес начала строки. В tempreg2 - длина таблицы)
;================================================================
flash_to_lcd:
	lpm		tempreg,Z+
	rcall	lcd_write_byte
	dec		tempreg2
	brne	flash_to_lcd
	ret

;================================================================
; Запись строки в CG_RAM LCD из памяти программ (на входе - в рег. Z
; адрес начала строки. В tempreg2 - длина таблицы)
;================================================================
flash_to_CG_RAM_lcd:
	lpm		tempreg,Z+
	rcall	lcd_write_byte
	dec		tempreg2
	brne	flash_to_CG_RAM_lcd
	ldi		tempreg,0x80				// Возвращаем на DD_RAM
	ClearRS
	rcall	lcd_write_byte
	ret

;================================================================
; ПП записи байта (на входе - tempreg - байт для передачи)
;================================================================
lcd_write_byte:
	push	tempreg
	rcall	lcd_decode_data
	in		tempreg1,LCD_DATA_PORT
	cbr		tempreg1,(1<<D4|1<<D5|1<<D6|1<<D7)
	or		tempreg1,tempreg
	out		LCD_DATA_PORT,tempreg1
	/*rcall	lcd_busy_delay*/
	rcall	LCD_1ms_delay
	SetE
	LCD_Delay
	ClearE
	pop		tempreg
	swap	tempreg
lcd_write_high_nibble:
	rcall	lcd_decode_data
	in		tempreg1,LCD_DATA_PORT
	cbr		tempreg1,(1<<D4|1<<D5|1<<D6|1<<D7)
	or		tempreg1,tempreg
	out		LCD_DATA_PORT,tempreg1
	/*rcall	lcd_short_delay*/
	rcall	LCD_160us_delay
	SetE
	LCD_Delay
	ClearE
	in		tempreg1,LCD_DATA_PORT
	cbr		tempreg1,(1<<D4|1<<D5|1<<D6|1<<D7)
	out		LCD_DATA_PORT,tempreg1	
	ret

;================================================================
; ПП декодирование данных для передачи (в tempreg - данные)
;================================================================
lcd_decode_data:
	push	tempreg1
	clr		tempreg1

	sbrc	tempreg,4
	sbr		tempreg1,(1<<D4)
	sbrc	tempreg,5
	sbr		tempreg1,(1<<D5)
	sbrc	tempreg,6
	sbr		tempreg1,(1<<D6)
	sbrc	tempreg,7
	sbr		tempreg1,(1<<D7)

	mov		tempreg,tempreg1
	pop		tempreg1
	ret

;================================================================
; ПП установки курсора на позицию
;================================================================
lcd_set_cur:
	ClearRS							// Передаем команду
	tst		tempreg1
	breq	set_cur_into_first_line
	cpi		tempreg1,2
	breq	set_cur_into_third_line
	cpi		tempreg1,3
	breq	set_cur_into_fourth_line
	ldi		tempreg1,0x40
	add		tempreg,tempreg1
	rjmp	set_cur_into_first_line
set_cur_into_third_line:
	ldi		tempreg1,0x14
	add		tempreg,tempreg1
	rjmp	set_cur_into_first_line
set_cur_into_fourth_line:
	ldi		tempreg1,0x54
	add		tempreg,tempreg1
set_cur_into_first_line:
	ori		tempreg,0x80
	rcall	lcd_write_byte
	ret

;================================================================
; Формирование выдержек времени для LCD
;================================================================

LCD_16ms_delay:											// Выдержка 16 мс
	ldi		Xh,high(XTAL/250)
	ldi		Xl,low(XTAL/250)
	rjmp	pc+9
LCD_5ms_delay:												// Выдержка 5 мс		
	ldi		Xh,high(XTAL/800)
	ldi		Xl,low(XTAL/800)
	rjmp	pc+6
LCD_1ms_delay:											// Выдержка 1 мс		
	ldi		Xh,high(XTAL/4000)
	ldi		Xl,low(XTAL/4000)
	rjmp	pc+3
LCD_160us_delay:											// Выдержка 160 мкс
	ldi		Xh,high(XTAL/25000)
	ldi		Xl,low(XTAL/25000)
	
	sbiw	X,1
	brne	pc-1
	ret

#ifdef USE_RUS_SYMB
	.include	"LCD_HD44780\Rus_symbol.asm"
#endif

