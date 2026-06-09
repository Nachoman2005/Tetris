extends Control

const COLS := 10
const ROWS := 20
const LINE_POINTS := [0, 100, 300, 500, 800]
const PIECES := {
	"I": [[1, 1, 1, 1]],
	"O": [[2, 2], [2, 2]],
	"T": [[0, 3, 0], [3, 3, 3]],
	"S": [[0, 4, 4], [4, 4, 0]],
	"Z": [[5, 5, 0], [0, 5, 5]],
	"J": [[6, 0, 0], [6, 6, 6]],
	"L": [[0, 0, 7], [7, 7, 7]],
}
const PIECE_NAMES := ["mate", "dulce", "bandoneon", "potrero", "campeon", "tango", "hinchada"]
const PIECE_COLORS := [
	Color.TRANSPARENT,
	Color("#76c7f2"),
	Color("#f7c948"),
	Color("#5ed5a8"),
	Color("#f25f5c"),
	Color("#8e6ad8"),
	Color("#f39b2f"),
	Color("#ffffff"),
]
const REGION_LOGO := Rect2(137, 48, 1120, 210)
const REGION_SCORE_PANEL := Rect2(30, 173, 550, 603)
const REGION_NEXT_PANEL := Rect2(686, 178, 318, 304)
const REGION_PAUSE_BUTTON := Rect2(1420, 198, 144, 160)
const REGION_PLAY_BUTTON := Rect2(1608, 198, 144, 160)
const REGION_MENU_TROPHY := Rect2(432, 208, 278, 304)
const POWERUP_REGIONS := [
	Rect2(582, 146, 300, 260), # VAR
	Rect2(1000, 126, 330, 280), # Aliento
	Rect2(56, 598, 350, 315), # Jugada de Potrero
]
const EFFECT_REGIONS := [
	Rect2(48, 154, 260, 220), # Papelitos
	Rect2(548, 154, 240, 220), # Nube
	Rect2(58, 606, 300, 280), # Burst
	Rect2(1108, 612, 275, 260), # Red
]
const CROWD_REGIONS := [
	Rect2(98, 174, 330, 300),
	Rect2(548, 170, 335, 305),
	Rect2(1008, 174, 335, 300),
	Rect2(84, 590, 345, 270),
	Rect2(548, 584, 345, 285),
	Rect2(1018, 590, 340, 278),
]
const COMBO_REGIONS := [
	Rect2(84, 150, 300, 230),
	Rect2(570, 130, 270, 280),
	Rect2(956, 160, 370, 250),
	Rect2(72, 620, 380, 300),
	Rect2(558, 668, 330, 250),
	Rect2(1038, 640, 305, 270),
]
const REWARD_REGIONS := [
	Rect2(96, 184, 270, 260),
	Rect2(460, 184, 280, 270),
	Rect2(772, 224, 260, 220),
	Rect2(1112, 226, 260, 220),
	Rect2(82, 594, 250, 260),
	Rect2(438, 628, 290, 220),
	Rect2(758, 614, 290, 250),
	Rect2(1138, 618, 250, 240),
]
const TROPHY_REGIONS := [
	Rect2(70, 137, 220, 280),
	Rect2(380, 145, 220, 250),
	Rect2(680, 176, 200, 220),
	Rect2(960, 176, 210, 220),
	Rect2(1210, 200, 280, 190),
	Rect2(1582, 164, 150, 230),
	Rect2(78, 508, 190, 220),
	Rect2(382, 538, 180, 190),
	Rect2(670, 528, 210, 210),
	Rect2(940, 520, 250, 200),
	Rect2(1222, 548, 300, 170),
	Rect2(1545, 515, 220, 220),
]

var board: Array = []
var current_piece: Dictionary = {}
var next_piece: Dictionary = {}
var current_pos := Vector2i.ZERO
var score := 0
var lines := 0
var level := 1
var argentris_count := 0
var drop_timer := 0.0
var drop_interval := 0.95
var playing := false
var paused := false
var game_over := false
var board_rect := Rect2()
var next_rect := Rect2()
var touch_start := Vector2.ZERO
var touch_last := Vector2.ZERO
var touch_moved := false
var banner_text := ""
var banner_time := 0.0
var selected_character := 0
var max_trophy_count := 0
var active_skin_index := 0
var ad_active := false
var ad_timer := 0.0
var ad_title := ""
var ad_body := ""
var ad_action := ""
var combo_streak := 0
var relator_text := ""
var relator_timer := 0.0
var slowmo_timer := 0.0
var powerup_charges := [1, 1, 1]
var previous_board: Array = []
var rng := RandomNumberGenerator.new()

@onready var root := VBoxContainer.new()
@onready var title_label := Label.new()
@onready var subtitle_label := Label.new()
@onready var score_label := Label.new()
@onready var level_label := Label.new()
@onready var lines_label := Label.new()
@onready var next_label := Label.new()
@onready var message_label := Label.new()
@onready var start_button := Button.new()
@onready var pause_button := Button.new()
@onready var character_button := Button.new()
@onready var left_button := Button.new()
@onready var rotate_button := Button.new()
@onready var right_button := Button.new()
@onready var drop_button := Button.new()
@onready var canvas := Control.new()
@onready var font_tex: Texture2D = preload("res://assets/graphics/processed/font.png")
@onready var trophies_tex: Texture2D = preload("res://assets/graphics/processed/trophies.png")
@onready var ui_tex: Texture2D = preload("res://assets/graphics/processed/UI.png")
@onready var buttons_tex: Texture2D = preload("res://assets/graphics/processed/menubuttons.png")
@onready var powerups_tex: Texture2D = preload("res://assets/graphics/processed/powerups/powerups_sheet.png")
@onready var combo_tex: Texture2D = preload("res://assets/graphics/processed/combo/asado_combo_sheet.png")
@onready var effects_tex: Texture2D = preload("res://assets/graphics/processed/effects/effects_sheet.png")
@onready var crowd_tex: Texture2D = preload("res://assets/graphics/processed/crowd/hinchada_sheet.png")
@onready var rewards_tex: Texture2D = preload("res://assets/graphics/processed/rewards/rewards_sheet.png")
@onready var music_player := AudioStreamPlayer.new()
@onready var background_music: AudioStream = preload("res://assets/music/The_Bandoneon_s_Gambit.mp3")
var skin_textures: Array[Texture2D] = []
var character_textures: Array[Texture2D] = []


func _ready() -> void:
	rng.randomize()
	skin_textures = _load_numbered_textures("res://assets/graphics/processed/skins", 16)
	character_textures = _load_numbered_textures("res://assets/graphics/processed/characters", 4)
	_build_ui()
	_setup_music()
	_new_board()
	next_piece = _random_piece()
	_update_active_skin()
	_update_hud()
	set_process(true)


func _setup_music() -> void:
	if background_music is AudioStreamMP3:
		(background_music as AudioStreamMP3).loop = true
	music_player.stream = background_music
	music_player.volume_db = -8.0
	music_player.finished.connect(func(): music_player.play())
	add_child(music_player)
	music_player.play()


func _process(delta: float) -> void:
	if ad_active:
		ad_timer = maxf(0.0, ad_timer - delta)
		canvas.queue_redraw()
	if relator_timer > 0.0:
		relator_timer = maxf(0.0, relator_timer - delta)
		canvas.queue_redraw()
	if slowmo_timer > 0.0:
		slowmo_timer = maxf(0.0, slowmo_timer - delta)
	if banner_time > 0.0:
		banner_time -= delta
		canvas.queue_redraw()
	if not playing or paused or ad_active:
		return
	var time_scale := 0.35 if slowmo_timer > 0.0 else 1.0
	drop_timer += delta * time_scale
	if drop_timer >= drop_interval:
		_soft_drop()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		_handle_keyboard(event)
	elif event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		return
	if event.is_action_pressed("move_left"):
		_move(Vector2i.LEFT)
	elif event.is_action_pressed("move_right"):
		_move(Vector2i.RIGHT)
	elif event.is_action_pressed("soft_drop"):
		_soft_drop()
	elif event.is_action_pressed("rotate_piece"):
		_rotate()
	elif event.is_action_pressed("hard_drop"):
		_hard_drop()
	elif event.is_action_pressed("pause_game"):
		_toggle_pause()


func _handle_keyboard(event: InputEventKey) -> void:
	if not event.pressed:
		return

	var handled := true
	match event.keycode:
		KEY_LEFT, KEY_A:
			_move(Vector2i.LEFT)
		KEY_RIGHT, KEY_D:
			_move(Vector2i.RIGHT)
		KEY_DOWN, KEY_S:
			_soft_drop()
		KEY_UP, KEY_W:
			if not event.echo:
				_rotate()
		KEY_SPACE:
			if not event.echo:
				_hard_drop()
		KEY_ENTER, KEY_KP_ENTER:
			if not event.echo and ad_active and ad_timer <= 0.0:
				_finish_ad()
			elif not event.echo and not playing:
				_start_game()
		KEY_P, KEY_ESCAPE:
			if not event.echo:
				if ad_active and ad_timer <= 0.0:
					_finish_ad()
				else:
					_toggle_pause()
		KEY_R:
			if not event.echo and game_over:
				_show_ad("PUBLICIDAD", "REINICIANDO NIVEL", "restart_level")
		KEY_C:
			if not event.echo:
				_cycle_character()
		KEY_1:
			if not event.echo:
				_use_powerup(0)
		KEY_2:
			if not event.echo:
				_use_powerup(1)
		KEY_3:
			if not event.echo:
				_use_powerup(2)
		_:
			handled = false

	if handled:
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	add_theme_color_override("font_color", Color("#eef8ff"))
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 10)
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(root)

	var header := VBoxContainer.new()
	header.alignment = BoxContainer.ALIGNMENT_CENTER
	title_label.text = "ARGENTRIS"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 44)
	title_label.visible = false
	subtitle_label.text = "bloques, mate y potrero"
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.add_theme_font_size_override("font_size", 18)
	subtitle_label.visible = false
	header.add_child(title_label)
	header.add_child(subtitle_label)
	root.add_child(header)

	var stats := HBoxContainer.new()
	stats.alignment = BoxContainer.ALIGNMENT_CENTER
	stats.add_theme_constant_override("separation", 18)
	for label in [score_label, level_label, lines_label, next_label]:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 18)
		label.visible = false
		stats.add_child(label)
	root.add_child(stats)

	canvas.custom_minimum_size = Vector2(520, 760)
	canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	canvas.draw.connect(_draw_game)
	root.add_child(canvas)

	message_label.text = "PC: flechas/WASD, espacio, Enter y P. Movil: botones, tap y swipe."
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.add_theme_font_size_override("font_size", 16)
	message_label.visible = false
	root.add_child(message_label)

	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 10)
	start_button.text = ""
	pause_button.text = ""
	character_button.text = ""
	character_button.icon = _atlas_texture(buttons_tex, REGION_MENU_TROPHY)
	character_button.expand_icon = true
	start_button.icon = _atlas_texture(ui_tex, REGION_PLAY_BUTTON)
	pause_button.icon = _atlas_texture(ui_tex, REGION_PAUSE_BUTTON)
	start_button.expand_icon = true
	pause_button.expand_icon = true
	start_button.custom_minimum_size = Vector2(76, 76)
	pause_button.custom_minimum_size = Vector2(76, 76)
	character_button.custom_minimum_size = Vector2(76, 76)
	start_button.pressed.connect(_start_game)
	pause_button.pressed.connect(_toggle_pause)
	character_button.pressed.connect(_cycle_character)
	actions.add_child(start_button)
	actions.add_child(pause_button)
	actions.add_child(character_button)
	root.add_child(actions)

	var controls := GridContainer.new()
	controls.columns = 3
	controls.add_theme_constant_override("h_separation", 10)
	controls.add_theme_constant_override("v_separation", 10)
	for button in [left_button, rotate_button, right_button, drop_button]:
		button.custom_minimum_size = Vector2(150, 76)
		button.add_theme_font_size_override("font_size", 24)
	left_button.text = "<"
	rotate_button.text = "Girar"
	right_button.text = ">"
	drop_button.text = "Caida"
	left_button.pressed.connect(func(): _move(Vector2i.LEFT))
	right_button.pressed.connect(func(): _move(Vector2i.RIGHT))
	rotate_button.pressed.connect(_rotate)
	drop_button.pressed.connect(_hard_drop)
	controls.add_child(left_button)
	controls.add_child(rotate_button)
	controls.add_child(right_button)
	controls.add_child(drop_button)
	root.add_child(controls)


func _start_game() -> void:
	_new_board()
	score = 0
	lines = 0
	level = 1
	argentris_count = 0
	max_trophy_count = 0
	active_skin_index = 0
	combo_streak = 0
	relator_text = ""
	relator_timer = 0.0
	slowmo_timer = 0.0
	powerup_charges = [1, 1, 1]
	previous_board = []
	drop_interval = 0.95
	drop_timer = 0.0
	playing = true
	paused = false
	game_over = false
	ad_active = false
	_update_active_skin()
	next_piece = _random_piece()
	_spawn_piece()
	message_label.text = "PC: flechas/WASD, espacio, P. Movil: tap, swipe y botones."
	_update_hud()
	canvas.queue_redraw()


func _new_board() -> void:
	board.clear()
	for y in range(ROWS):
		var row: Array[int] = []
		for x in range(COLS):
			row.append(0)
		board.append(row)


func _random_piece() -> Dictionary:
	var keys := PIECES.keys()
	var key: String = keys[rng.randi_range(0, keys.size() - 1)]
	var matrix: Array = []
	for row in PIECES[key]:
		matrix.append(row.duplicate())
	return {
		"key": key,
		"matrix": matrix,
		"theme": PIECE_NAMES[rng.randi_range(0, PIECE_NAMES.size() - 1)],
	}


func _spawn_piece() -> void:
	current_piece = next_piece
	next_piece = _random_piece()
	current_pos = Vector2i((COLS - current_piece.matrix[0].size()) / 2, 0)
	if _collides(current_piece.matrix, current_pos):
		playing = false
		game_over = true
		message_label.text = "Fin del partido. Puntaje: %s" % score
		_show_ad("PUBLICIDAD", "REINICIAR NIVEL", "restart_level")
	_update_hud()


func _collides(matrix: Array, pos: Vector2i) -> bool:
	for y in range(matrix.size()):
		for x in range(matrix[y].size()):
			if matrix[y][x] == 0:
				continue
			var bx := pos.x + x
			var by := pos.y + y
			if bx < 0 or bx >= COLS or by >= ROWS:
				return true
			if by >= 0 and board[by][bx] != 0:
				return true
	return false


func _move(dir: Vector2i) -> void:
	if not _can_act():
		return
	var next_pos := current_pos + dir
	if not _collides(current_piece.matrix, next_pos):
		current_pos = next_pos
		canvas.queue_redraw()


func _soft_drop() -> void:
	if not _can_act():
		return
	drop_timer = 0.0
	var next_pos := current_pos + Vector2i.DOWN
	if _collides(current_piece.matrix, next_pos):
		_lock_piece()
	else:
		current_pos = next_pos
		canvas.queue_redraw()


func _hard_drop() -> void:
	if not _can_act():
		return
	while not _collides(current_piece.matrix, current_pos + Vector2i.DOWN):
		current_pos += Vector2i.DOWN
	score += 2
	_lock_piece()


func _rotate() -> void:
	if not _can_act():
		return
	var rotated := _rotated(current_piece.matrix)
	for kick in [0, -1, 1, -2, 2]:
		var test_pos := current_pos + Vector2i(kick, 0)
		if not _collides(rotated, test_pos):
			current_piece.matrix = rotated
			current_pos = test_pos
			canvas.queue_redraw()
			return


func _rotated(matrix: Array) -> Array:
	var result: Array = []
	var width: int = matrix[0].size()
	var height: int = matrix.size()
	for x in range(width):
		var row: Array[int] = []
		for y in range(height - 1, -1, -1):
			row.append(matrix[y][x])
		result.append(row)
	return result


func _lock_piece() -> void:
	previous_board = _clone_board(board)
	for y in range(current_piece.matrix.size()):
		for x in range(current_piece.matrix[y].size()):
			var val: int = current_piece.matrix[y][x]
			if val == 0:
				continue
			var bx := current_pos.x + x
			var by := current_pos.y + y
			if by >= 0 and by < ROWS and bx >= 0 and bx < COLS:
				board[by][bx] = val
	_clear_lines()
	_spawn_piece()
	canvas.queue_redraw()


func _clear_lines() -> void:
	var cleared := 0
	for y in range(ROWS - 1, -1, -1):
		var full := true
		for x in range(COLS):
			if board[y][x] == 0:
				full = false
				break
		if full:
			board.remove_at(y)
			var row: Array[int] = []
			for x in range(COLS):
				row.append(0)
			board.push_front(row)
			cleared += 1
	if cleared == 0:
		combo_streak = 0
		return
	var previous_level := level
	combo_streak += 1
	score += LINE_POINTS[cleared] * level
	lines += cleared
	level = int(lines / 10) + 1
	if level > previous_level:
		max_trophy_count = maxi(max_trophy_count, mini(level - 1, TROPHY_REGIONS.size()))
		_update_active_skin()
		_show_ad("PUBLICIDAD", "NIVEL %s" % level, "continue")
	drop_interval = maxf(0.12, 0.95 - float(level - 1) * 0.075)
	if cleared == 4:
		argentris_count += 1
		_show_banner("ARGENTRIS!")
	else:
		_show_banner("Vamos!")
	_show_relator(_relator_phrase(cleared))
	_update_hud()


func _toggle_pause() -> void:
	if not playing or ad_active:
		return
	paused = not paused
	message_label.text = "Pausa" if paused else "PC: flechas/WASD, espacio, P. Movil: tap, swipe y botones."
	canvas.queue_redraw()


func _cycle_character() -> void:
	if character_textures.is_empty():
		return
	selected_character = (selected_character + 1) % character_textures.size()
	canvas.queue_redraw()


func _use_powerup(index: int) -> void:
	if index < 0 or index >= powerup_charges.size() or powerup_charges[index] <= 0:
		return
	if not playing or ad_active:
		return
	powerup_charges[index] -= 1
	match index:
		0:
			if previous_board.is_empty():
				powerup_charges[index] += 1
				_show_relator("NO HAY VAR")
				return
			board = _clone_board(previous_board)
			_show_relator("VAR REVISA")
		1:
			slowmo_timer = 5.0
			_show_relator("ALIENTO DE HINCHADA")
		2:
			_clear_lowest_rows(2)
			_show_relator("JUGADA DE POTRERO")
	_update_hud()
	canvas.queue_redraw()


func _clear_lowest_rows(amount: int) -> void:
	var cleared := 0
	for y in range(ROWS - 1, -1, -1):
		var occupied := false
		for x in range(COLS):
			if board[y][x] != 0:
				occupied = true
				break
		if occupied:
			board.remove_at(y)
			var row: Array[int] = []
			for x in range(COLS):
				row.append(0)
			board.push_front(row)
			cleared += 1
			if cleared >= amount:
				break
	if cleared > 0:
		score += 250 * cleared * level
		lines += cleared


func _show_relator(text: String) -> void:
	relator_text = text
	relator_timer = 2.2


func _relator_phrase(cleared: int) -> String:
	if cleared >= 4:
		return "ESTO ES ARGENTRIS"
	if combo_streak >= 3:
		return "SE ARMO EL ASADO"
	var phrases := [
		"LINEA LIMPIA",
		"QUE MANERA DE ACOMODAR",
		"SE PICO EL TABLERO",
		"UNA GENIALIDAD DE BARRIO",
	]
	return phrases[rng.randi_range(0, phrases.size() - 1)]


func _clone_board(source: Array) -> Array:
	var copy: Array = []
	for row in source:
		copy.append(row.duplicate())
	return copy


func _show_ad(title: String, body: String, action: String) -> void:
	ad_active = true
	ad_timer = 3.0
	ad_title = title
	ad_body = body
	ad_action = action
	paused = true
	canvas.queue_redraw()


func _finish_ad() -> void:
	var action := ad_action
	ad_active = false
	ad_timer = 0.0
	ad_action = ""
	if action == "restart_level":
		_restart_current_level()
	else:
		paused = false
	canvas.queue_redraw()


func _restart_current_level() -> void:
	_new_board()
	game_over = false
	playing = true
	paused = false
	drop_timer = 0.0
	next_piece = _random_piece()
	_spawn_piece()
	_update_hud()


func _update_active_skin() -> void:
	if skin_textures.is_empty():
		active_skin_index = 0
		return
	if level <= skin_textures.size():
		active_skin_index = level - 1
	else:
		active_skin_index = rng.randi_range(0, skin_textures.size() - 1)


func _can_act() -> bool:
	return playing and not paused and not game_over and not current_piece.is_empty()


func _update_hud() -> void:
	score_label.text = "Puntos\n%s" % score
	level_label.text = "Nivel\n%s" % level
	lines_label.text = "Lineas\n%s" % lines
	next_label.text = "Proximo\n%s" % next_piece.get("theme", "mate")
	pause_button.disabled = not playing


func _show_banner(text: String) -> void:
	banner_text = text
	banner_time = 1.2


func _handle_touch(event: InputEventScreenTouch) -> void:
	var local_pos := event.position - canvas.global_position
	if ad_active:
		if not event.pressed and ad_timer <= 0.0:
			_finish_ad()
		return
	if event.pressed:
		touch_start = local_pos
		touch_last = local_pos
		touch_moved = false
	else:
		var delta := local_pos - touch_start
		if not touch_moved and board_rect.has_point(local_pos):
			_rotate()
		elif delta.y > 60 and absf(delta.y) > absf(delta.x):
			_hard_drop()


func _handle_drag(event: InputEventScreenDrag) -> void:
	var local_pos := event.position - canvas.global_position
	if not board_rect.has_point(local_pos):
		return
	var cell := board_rect.size.x / COLS
	var delta := local_pos - touch_last
	if absf(delta.x) >= cell:
		_move(Vector2i.RIGHT if delta.x > 0 else Vector2i.LEFT)
		touch_last = local_pos
		touch_moved = true


func _draw_game() -> void:
	var area := Rect2(Vector2.ZERO, canvas.size)
	var bg := Color("#0b1020")
	canvas.draw_rect(area, bg)
	_draw_background(area)
	_draw_tex(font_tex, REGION_LOGO, Rect2(Vector2(area.size.x * 0.5 - 190, 8), Vector2(380, 72)))
	var cell := floorf(minf(area.size.x * 0.68 / COLS, area.size.y * 0.92 / ROWS))
	cell = clampf(cell, 18.0, 42.0)
	var board_size := Vector2(cell * COLS, cell * ROWS)
	board_rect = Rect2(Vector2((area.size.x - board_size.x) * 0.5, maxf(86.0, (area.size.y - board_size.y) * 0.5)), board_size)
	_draw_board(board_rect, cell)
	var side_x := board_rect.end.x + 18.0
	next_rect = Rect2(Vector2(side_x, board_rect.position.y + 12), Vector2(minf(120.0, area.size.x - side_x - 12), minf(120.0, area.size.x - side_x - 12)))
	if next_rect.size.x > 36.0:
		_draw_next(next_rect)
	_draw_score_panel(area)
	_draw_trophies(area)
	_draw_selected_character(area)
	_draw_powerups(area)
	_draw_combo_fx(area)
	_draw_relator(area)
	if paused:
		_draw_center_text("PAUSA", Color("#f7c948"))
	elif game_over:
		_draw_center_text("FIN", Color("#f25f5c"))
	elif not playing:
		_draw_center_text("TOCA JUGAR", Color("#f7c948"))
	if banner_time > 0.0:
		_draw_center_text(banner_text, Color("#f7c948"))
	if ad_active:
		_draw_ad_overlay(area)


func _draw_background(area: Rect2) -> void:
	canvas.draw_rect(Rect2(area.position, Vector2(area.size.x, area.size.y * 0.24)), Color("#76c7f2"))
	canvas.draw_rect(Rect2(Vector2(0, area.size.y * 0.76), Vector2(area.size.x, area.size.y * 0.24)), Color("#76c7f2"))
	for x in range(0, int(area.size.x), 44):
		canvas.draw_line(Vector2(x, 0), Vector2(x - 120, area.size.y), Color(1, 1, 1, 0.04), 2.0)


func _draw_board(rect: Rect2, cell: float) -> void:
	canvas.draw_rect(rect.grow(8), Color("#101827"))
	canvas.draw_rect(rect.grow(5), Color("#eef8ff"), false, 3.0)
	for y in range(ROWS):
		for x in range(COLS):
			var block_rect := Rect2(rect.position + Vector2(x * cell, y * cell), Vector2(cell, cell))
			canvas.draw_rect(block_rect, Color("#07111f"))
			canvas.draw_rect(block_rect, Color("#22324a"), false, 1.0)
			var val: int = board[y][x]
			if val != 0:
				_draw_block(block_rect, val)
	if playing and not current_piece.is_empty():
		var ghost_y := current_pos.y
		while not _collides(current_piece.matrix, Vector2i(current_pos.x, ghost_y + 1)):
			ghost_y += 1
		_draw_piece(rect, cell, current_piece.matrix, Vector2i(current_pos.x, ghost_y), 0.22)
		_draw_piece(rect, cell, current_piece.matrix, current_pos, 1.0)


func _draw_piece(rect: Rect2, cell: float, matrix: Array, pos: Vector2i, alpha: float) -> void:
	for y in range(matrix.size()):
		for x in range(matrix[y].size()):
			var val: int = matrix[y][x]
			if val == 0:
				continue
			var block_rect := Rect2(rect.position + Vector2((pos.x + x) * cell, (pos.y + y) * cell), Vector2(cell, cell))
			_draw_block(block_rect, val, alpha)


func _draw_block(rect: Rect2, val: int, alpha: float = 1.0) -> void:
	var color: Color = PIECE_COLORS[val]
	color.a = alpha
	var target := rect.grow(-1)
	if not skin_textures.is_empty():
		var tex := skin_textures[clampi(active_skin_index, 0, skin_textures.size() - 1)]
		_draw_full_tex(tex, target, Color(1, 1, 1, alpha))
	else:
		canvas.draw_rect(target, color)
		canvas.draw_rect(Rect2(rect.position + Vector2(3, 3), Vector2(rect.size.x - 6, rect.size.y * 0.18)), Color(1, 1, 1, 0.22 * alpha))
	canvas.draw_rect(target, Color(0, 0, 0, 0.42 * alpha), false, 2.0)


func _draw_next(rect: Rect2) -> void:
	_draw_tex(ui_tex, REGION_NEXT_PANEL, rect.grow(8), Color(1, 1, 1, 0.92))
	if next_piece.is_empty():
		return
	var matrix: Array = next_piece.matrix
	var cell := floorf(minf(rect.size.x / 4.0, rect.size.y / 4.0))
	var offset := rect.position + (rect.size - Vector2(matrix[0].size() * cell, matrix.size() * cell)) * 0.5
	for y in range(matrix.size()):
		for x in range(matrix[y].size()):
			var val: int = matrix[y][x]
			if val != 0:
				_draw_block(Rect2(offset + Vector2(x * cell, y * cell), Vector2(cell, cell)), val)


func _draw_score_panel(area: Rect2) -> void:
	var panel_w := minf(142.0, maxf(118.0, board_rect.position.x - 12.0))
	var panel := Rect2(Vector2(8, board_rect.position.y + 20), Vector2(panel_w, 176))
	_draw_tex(ui_tex, REGION_SCORE_PANEL, panel, Color(1, 1, 1, 0.94))
	var label_h := 9.0
	var value_h := 13.0
	_draw_bitmap_text("SCORE", panel.position + Vector2(26, 24), label_h)
	_draw_bitmap_text(str(score), panel.position + Vector2(26, 42), value_h)
	_draw_bitmap_text("LINEAS", panel.position + Vector2(22, 82), label_h)
	_draw_bitmap_text(str(lines), panel.position + Vector2(22, 100), value_h)
	_draw_bitmap_text("NIVEL", panel.position + Vector2(panel_w * 0.58, 82), label_h)
	_draw_bitmap_text(str(level), panel.position + Vector2(panel_w * 0.62, 100), value_h)


func _draw_powerups(area: Rect2) -> void:
	var icon := 34.0
	var start := Vector2(10, board_rect.position.y + 208)
	for i in range(POWERUP_REGIONS.size()):
		var target := Rect2(start + Vector2(i * (icon + 8), 0), Vector2(icon, icon))
		_draw_tex(powerups_tex, POWERUP_REGIONS[i], target, Color(1, 1, 1, 0.95 if powerup_charges[i] > 0 else 0.35))
		_draw_bitmap_text(str(i + 1), target.position + Vector2(10, icon + 3), 9)
		_draw_bitmap_text("X%s" % powerup_charges[i], target.position + Vector2(0, icon + 16), 8)


func _draw_trophies(area: Rect2) -> void:
	if max_trophy_count <= 0:
		_draw_bitmap_text("TROFEOS 0", Vector2(12, area.size.y - 32), 10)
		return
	var icon_size := 34.0
	var start := Vector2(10, area.size.y - icon_size - 8)
	for i in range(max_trophy_count):
		if i >= TROPHY_REGIONS.size():
			break
		var target := Rect2(start + Vector2(i * (icon_size + 4), 0), Vector2(icon_size, icon_size))
		_draw_tex(trophies_tex, TROPHY_REGIONS[i], target)


func _draw_combo_fx(area: Rect2) -> void:
	if combo_streak <= 0 and banner_time <= 0.0:
		return
	var crowd_idx: int = combo_streak % CROWD_REGIONS.size()
	var crowd_region: Rect2 = CROWD_REGIONS[crowd_idx]
	var crowd_h: float = minf(82.0, area.size.y * 0.1)
	var crowd_w: float = crowd_h * crowd_region.size.x / crowd_region.size.y
	_draw_tex(crowd_tex, crowd_region, Rect2(Vector2(12, board_rect.end.y - crowd_h - 10), Vector2(crowd_w, crowd_h)), Color(1, 1, 1, 0.88))
	var combo_idx: int = mini(maxi(combo_streak - 1, 0), COMBO_REGIONS.size() - 1)
	if combo_streak >= 2:
		_draw_tex(combo_tex, COMBO_REGIONS[combo_idx], Rect2(Vector2(board_rect.end.x + 8, board_rect.end.y - 96), Vector2(86, 76)), Color(1, 1, 1, 0.86))
	if banner_time > 0.0:
		var fx_idx: int = argentris_count % EFFECT_REGIONS.size()
		_draw_tex(effects_tex, EFFECT_REGIONS[fx_idx], Rect2(board_rect.get_center() - Vector2(88, 72), Vector2(176, 144)), Color(1, 1, 1, minf(1.0, banner_time)))


func _draw_selected_character(area: Rect2) -> void:
	if character_textures.is_empty():
		return
	var texture := character_textures[clampi(selected_character, 0, character_textures.size() - 1)]
	var height: float = minf(145.0, area.size.y * 0.18)
	var width: float = height * float(texture.get_width()) / float(texture.get_height())
	var pos: Vector2 = Vector2(area.size.x - width - 10, area.size.y - height - 8)
	_draw_full_tex(texture, Rect2(pos, Vector2(width, height)), Color(1, 1, 1, 0.92))
	_draw_bitmap_text("PERSONAJE", Vector2(pos.x, pos.y - 24), 9)


func _draw_relator(area: Rect2) -> void:
	if relator_timer <= 0.0 or relator_text.is_empty():
		return
	var text_h := 15.0
	var size := _bitmap_text_size(relator_text, text_h)
	var pos := Vector2((area.size.x - size.x) * 0.5, board_rect.position.y - 24)
	canvas.draw_rect(Rect2(pos - Vector2(10, 6), size + Vector2(20, 13)), Color(0, 0, 0, 0.62))
	_draw_bitmap_text(relator_text, pos, text_h)


func _draw_tex(texture: Texture2D, source: Rect2, target: Rect2, modulate: Color = Color.WHITE) -> void:
	if texture:
		canvas.draw_texture_rect_region(texture, target, source, modulate)


func _draw_full_tex(texture: Texture2D, target: Rect2, modulate: Color = Color.WHITE) -> void:
	if texture:
		canvas.draw_texture_rect(texture, target, false, modulate)


func _atlas_texture(texture: Texture2D, region: Rect2) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = region
	return atlas


func _load_numbered_textures(base_path: String, count: int) -> Array[Texture2D]:
	var textures: Array[Texture2D] = []
	for i in range(1, count + 1):
		var path := "%s/%s.png" % [base_path, i]
		if ResourceLoader.exists(path):
			var texture := load(path) as Texture2D
			if texture:
				textures.append(texture)
	return textures


func _draw_center_text(text: String, color: Color) -> void:
	var scale := 24.0
	var size := _bitmap_text_size(text, scale)
	var pos := board_rect.get_center() - size * 0.5
	canvas.draw_rect(Rect2(pos - Vector2(18, 12), size + Vector2(36, 24)), Color(0, 0, 0, 0.72))
	_draw_bitmap_text(text, pos, scale, color)


func _draw_ad_overlay(area: Rect2) -> void:
	canvas.draw_rect(area, Color(0, 0, 0, 0.82))
	var panel := Rect2(area.get_center() - Vector2(190, 150), Vector2(380, 300))
	canvas.draw_rect(panel, Color("#101827"))
	canvas.draw_rect(panel, Color("#f7c948"), false, 4.0)
	_draw_bitmap_text(ad_title, panel.position + Vector2(42, 34), 24)
	_draw_bitmap_text(ad_body, panel.position + Vector2(42, 94), 16)
	_draw_bitmap_text("ESPACIO PUBLICITARIO", panel.position + Vector2(42, 138), 12)
	_draw_bitmap_text("AQUI VA ADMOB", panel.position + Vector2(42, 164), 12)
	var reward_idx := maxi(level - 1, 0) % REWARD_REGIONS.size()
	_draw_tex(rewards_tex, REWARD_REGIONS[reward_idx], Rect2(panel.position + Vector2(panel.size.x - 112, 122), Vector2(76, 76)))
	if ad_timer > 0.0:
		_draw_bitmap_text("ESPERA %s" % ceili(ad_timer), panel.position + Vector2(42, 224), 14)
	else:
		_draw_bitmap_text("ENTER PARA SEGUIR", panel.position + Vector2(42, 224), 14)


func _draw_bitmap_text(text: String, pos: Vector2, height: float, modulate: Color = Color.WHITE) -> void:
	var cursor := pos
	for raw_char in text.to_upper():
		if raw_char == " ":
			cursor.x += height * 0.55
			continue
		var source := _font_region(raw_char)
		if source.size == Vector2.ZERO:
			cursor.x += height * 0.45
			continue
		var width := height * source.size.x / source.size.y
		_draw_tex(font_tex, source, Rect2(cursor, Vector2(width, height)), modulate)
		cursor.x += width + height * 0.08


func _bitmap_text_size(text: String, height: float) -> Vector2:
	var width := 0.0
	for raw_char in text.to_upper():
		if raw_char == " ":
			width += height * 0.55
			continue
		var source := _font_region(raw_char)
		width += (height * source.size.x / source.size.y) + height * 0.08 if source.size != Vector2.ZERO else height * 0.45
	return Vector2(width, height)


func _font_region(character: String) -> Rect2:
	var alphabet_1 := "ABCDEFGHIJKLMNÑOPQRS"
	var idx := alphabet_1.find(character)
	if idx >= 0:
		return Rect2(26 + idx * 74, 380, 62, 78)
	var alphabet_2 := "TUVWXYZ"
	idx = alphabet_2.find(character)
	if idx >= 0:
		return Rect2(448 + idx * 76, 482, 62, 78)
	var digits := "0123456789"
	idx = digits.find(character)
	if idx >= 0:
		return Rect2(324 + idx * 77, 586, 62, 78)
	match character:
		"!":
			return Rect2(253, 686, 32, 70)
		"?":
			return Rect2(310, 686, 58, 70)
		".":
			return Rect2(394, 720, 30, 36)
		",":
			return Rect2(468, 720, 30, 40)
		":":
			return Rect2(522, 686, 28, 70)
		"-":
			return Rect2(684, 708, 55, 28)
		_:
			return Rect2()
