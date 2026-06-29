;++++++++++++++++++++++++++++++++++++++++++++++++++++
; Сегмент данных
;++++++++++++++++++++++++++++++++++++++++++++++++++++
.dseg
	
	.include	"Data.asm"

;++++++++++++++++++++++++++++++++++++++++++++++++++++
; Сегмент EEPROM
;++++++++++++++++++++++++++++++++++++++++++++++++++++
.eseg

;++++++++++++++++++++++++++++++++++++++++++++++++++++
; Сегмент кода
;++++++++++++++++++++++++++++++++++++++++++++++++++++

.cseg
	.include	"Define.asm"
	.include	"Init.asm"

	rjmp	start

	.include	"LCD_HD44780\LCD_HD44780.asm"
	.include	"Buttons\ButOpros.asm"
	.include	"Buzzer\Buzzer.asm"
	.include	"Blinker\Blinker.asm"
	.include	"SoftTimer\SoftTimer.asm"
	.include	"OneWire\OWIMaster.asm"
	.include	"OneWire\OWIMasterReadSN.asm"
	.include	"OneWire\OWIMasterWriteSN.asm"
	.include	"OneWire\RW1990.asm"
	.include	"OneWire\TM2004.asm"
	.include	"PrintFuncs\PrintSerNo.asm"
	.include	"PrintFuncs\Messages.asm"
	.include	"ControlFuncs\CRCCalc.asm"
	.include	"ControlFuncs\VerifySerNo.asm"

start:

;++++++++++++++++++++++++++++++++++++++++++++++++++++
; Начало программы
;++++++++++++++++++++++++++++++++++++++++++++++++++++

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Запускаем прерывания
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	sei

	rcall	set_read_mode


start_main:

	LCD_cursor_off
	BLINKER_RED

;++++++++++++++++++++++++++++++++++++++++++++++++++++
; Главный цикл (режим выбора режима)
;++++++++++++++++++++++++++++++++++++++++++++++++++++

main:
	sbrc	flags,light_off_flag
	rcall	backlight_off
	sbrc	flags,ButOpros_flag
	rcall	ButOpros
	sbrs	mode,selection_mode
	rjmp	choose_work_mode
	rjmp	main


start_reading:
	ldi		mode,(1<<read_mode)
	cbr		flags,(1<<owi_master_read_flag)
	rcall	one_wire_timer_init
	LCD_set_cursor	0,0
	rcall	clear_row
	LCD_set_cursor	0,0
	rcall	print_reading

main_reading:
	sbrc	flags,light_off_flag
	rcall	backlight_off
	sbrc	flags,ButOpros_flag
	rcall	ButOpros
	sbrc	flags,blinker_flag
	rcall	blinker_blink
	sbrc	flags,owi_master_read_flag
	rcall	owi_master_read_sn
	sbrc	mode,selection_mode
	rjmp	start_main
	rjmp	main_reading



start_writing:

	ldi		mode,(1<<write_mode)
	cbr		flags,(1<<owi_master_read_flag)
	rcall	one_wire_timer_init
	LCD_set_cursor	0,0
	rcall	clear_row
	LCD_set_cursor	0,0
	rcall	print_writing

	sbrc	flags,ser_no_readed
	rjmp	main_writing

	LCD_set_cursor	1,0
	rcall	clear_row
	LCD_set_cursor	1,0
	rcall	print_empty
	cbr		flags,(1<<owi_master_read_flag)
	rcall	one_wire_long_timer_init
	
	sbrs	flags,owi_master_read_flag
	rjmp	pc-1
	
	LCD_set_cursor	1,0
	rcall	clear_row	
	rcall	set_write_mode

	rjmp	start_main

main_writing:
	sbrc	flags,light_off_flag
	rcall	backlight_off
	sbrc	flags,ButOpros_flag
	rcall	ButOpros
	sbrc	flags,blinker_flag
	rcall	blinker_blink
	sbrc	flags,owi_master_read_flag
	rcall	owi_master_write_ser_no
	sbrc	mode,selection_mode
	rjmp	start_main
	rjmp	main_writing

start_editing:

	cbr		mode,(1<<edit_half_byte)

	clr		edited_half_byte

	BLINKER_RED
	LCD_set_cursor	0,0
	rcall	clear_row
	LCD_set_cursor	0,0
	rcall	print_editing
	rcall	print_ser_no

	LCD_set_cursor	1,15

	LCD_cursor_on	LCD_cur_underl

main_editing:
	sbrc	flags,light_off_flag
	rcall	backlight_off
	sbrc	flags,ButOpros_flag
	rcall	ButOpros
	sbrc	mode,selection_mode
	rjmp	start_main
	rjmp	main_editing


backlight_off:
	cbr		flags,(1<<light_off_flag)
	LightOff
ret


choose_work_mode:
	sbrc	mode,read_mode
	rjmp	start_reading
	sbrc	mode,write_mode
	rjmp	start_writing
	sbrc	mode,edit_mode
	rjmp	start_editing
	ret	


switch_mode_up:
	sbrc	mode,read_mode
	rjmp	set_edit_mode
	sbrc	mode,write_mode
	rjmp	set_read_mode
	sbrc	mode,edit_mode
	rjmp	set_write_mode
	ret

switch_mode_dwn:
	sbrc	mode,read_mode
	rjmp	set_write_mode
	sbrc	mode,write_mode
	rjmp	set_edit_mode
	sbrc	mode,edit_mode
	rjmp	set_read_mode
	ret

set_read_mode:
	ldi		mode,(1<<selection_mode|1<<read_mode)
	LCD_set_cursor	0,0
	rcall	clear_row
	LCD_set_cursor	0,5
	rcall	print_reading
	rcall	print_select_symbols
	ret

set_write_mode:
	ldi		mode,(1<<selection_mode|1<<write_mode)
	LCD_set_cursor	0,0
	rcall	clear_row
	LCD_set_cursor	0,5
	rcall	print_writing
	rcall	print_select_symbols
	ret

set_edit_mode:
	ldi		mode,(1<<selection_mode|1<<edit_mode)
	LCD_set_cursor	0,0
	rcall	clear_row
	LCD_set_cursor	0,1
	rcall	print_editing
	rcall	print_select_symbols
	ret

edit_mode_up:
	
	sbrs	mode,edit_half_byte
	rjmp	edit_mode_up_no_hb_edit
	rcall	prep_byte_for_inc_dec
	
	inc		tempreg
	sbrc	tempreg,4
	clr		tempreg

	rcall	save_byte_after_inc_dec
	ret

edit_mode_up_no_hb_edit:
	inc		edited_half_byte
	sbrc	edited_half_byte,4						; если = 16, то обнуляем
	clr		edited_half_byte

	rcall	edit_mode_set_cursor

	ret

edit_mode_dwn:
	
	sbrs	mode,edit_half_byte
	rjmp	edit_mode_dwn_no_hb_edit
	rcall	prep_byte_for_inc_dec
	
	dec		tempreg
	sbrc	tempreg,7
	ldi		tempreg,15

	rcall	save_byte_after_inc_dec
	ret

edit_mode_dwn_no_hb_edit:	
	dec		edited_half_byte
	sbrc	edited_half_byte,7						; если < 0, то = 15
	ldi		edited_half_byte,15

	rcall	edit_mode_set_cursor

	ret

edit_mode_enter:
	sbrs	mode,edit_half_byte
	rjmp	set_edit_half_byte_mode

	cbr		mode,(1<<edit_half_byte)
	LCD_cursor_on	LCD_cur_underl

	ret

set_edit_half_byte_mode:
	
	sbr		mode,(1<<edit_half_byte)
	LCD_cursor_on	LCD_cur_blink

	ret


search_adress_byte:
	mov		tempreg,edited_half_byte
	lsr		tempreg
	clr		tempreg1
	ldi		Zl,low(ibutton_ser_no)
	ldi		Zh,high(ibutton_ser_no)
	add		Zl,tempreg
	adc		Zh,tempreg1

	ld		tempreg,Z

	ret


prep_byte_for_inc_dec:
	rcall	search_adress_byte
	sbrc	edited_half_byte,0						; если четное
	swap	tempreg
	mov		tempreg1,tempreg
	cbr		tempreg1,0x0F
	cbr		tempreg,0xF0
	ret

	
save_byte_after_inc_dec:
	or		tempreg1,tempreg
	sbrc	edited_half_byte,0						; если четное
	swap	tempreg1
	st		Z,tempreg1
	rcall	print_half_byte
	rcall	ser_no_CRC_calc
	cbr		flags,(1<<ser_no_readed)
	tst		tempreg
	breq	pc+2
	sbr		flags,(1<<ser_no_readed)				; если CRC нулевой - значит весь ключ нули - значит как будто не считан

	cpi		edited_half_byte,14						; если редактирум старший байт номера (т.е. CRC), то проверку CRC пропускаем
	brsh	pc+9
	LCD_set_cursor	1,0
	lds		tempreg,(ibutton_ser_no_CRC)
	sts		(ibutton_ser_no+7),tempreg
	rcall	print_byte

	rcall	edit_mode_set_cursor
	ret


edit_mode_set_cursor:
	ldi		tempreg,15
	sub		tempreg,edited_half_byte				// столбец
	ldi		tempreg1,1								// строка
	rcall	lcd_set_cur
	ret
