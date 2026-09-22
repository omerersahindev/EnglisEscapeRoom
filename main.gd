extends Control

var level := 1
var locked := false

var themes = [
	["🚇 METRO", Color("#20252b")],
	["🏚️ TERK EDİLMİŞ EV", Color("#29251f")],
	["🧪 GİZLİ LABORATUVAR", Color("#20292b")],
	["🏰 ESKİ ŞATO", Color("#29242e")],
	["🌲 KARANLIK ORMAN", Color("#1d2922")],
	["❄️ BUZ ODASI", Color("#202a30")],
	["🏜️ ÇÖL TAPINAĞI", Color("#30281f")],
	["🚀 UZAY İSTASYONU", Color("#20232e")],
	["🌊 SU ALTINDA", Color("#1d2930")],
	["🕰️ SAAT KULESİ", Color("#29272d")]
]

var background: ColorRect
var title_label: Label
var puzzle_panel: ColorRect
var puzzle_label: Label
var room_label: Label
var door_a: Button
var door_b: Button
var door_c: Button
var result_label: Label


func _ready():
	create_escape_room()
	start_level()


func create_escape_room():

	# ARKA PLAN
	background = ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = themes[0][1]
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	# BAŞLIK
	title_label = Label.new()
	title_label.position = Vector2(0, 20)
	title_label.size = Vector2(800, 40)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 28)
	add_child(title_label)

	# ODA ADI
	room_label = Label.new()
	room_label.position = Vector2(0, 65)
	room_label.size = Vector2(800, 30)
	room_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_label.add_theme_font_size_override("font_size", 18)
	add_child(room_label)

	# BİLMECE PANELİ
	puzzle_panel = ColorRect.new()
	puzzle_panel.position = Vector2(80, 105)
	puzzle_panel.size = Vector2(640, 240) # Sorular sığsın diye paneli genişletip uzattık
	puzzle_panel.color = Color("#151719")
	add_child(puzzle_panel)

	puzzle_label = Label.new()
	puzzle_label.position = Vector2(20, 15)
	puzzle_label.size = Vector2(600, 210)
	puzzle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	puzzle_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	puzzle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	puzzle_label.add_theme_font_size_override("font_size", 16)
	puzzle_panel.add_child(puzzle_label)

	# KAPILAR (Aşağıya kaydırıldı)
	door_a = create_door("A")
	door_b = create_door("B")
	door_c = create_door("C")

	door_a.position = Vector2(110, 380) # Y-ekseni 320 -> 380 yapıldı
	door_b.position = Vector2(325, 380)
	door_c.position = Vector2(540, 380)

	add_child(door_a)
	add_child(door_b)
	add_child(door_c)

	door_a.pressed.connect(func(): choose_door(0))
	door_b.pressed.connect(func(): choose_door(1))
	door_c.pressed.connect(func(): choose_door(2))

	# ALT MESAJ (Sayfa altına ayarlandı)
	result_label = Label.new()
	result_label.position = Vector2(0, 620)
	result_label.size = Vector2(800, 40)
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.add_theme_font_size_override("font_size", 18)
	add_child(result_label)


func create_door(letter: String) -> Button:

	var door = Button.new()

	door.text = "🚪\n" + letter
	door.size = Vector2(150, 220)

	door.add_theme_font_size_override("font_size", 30)

	return door


func start_level():

	locked = false

	if level > 100:
		finish_game()
		return

	var theme_index = int((level - 1) / 10)

	var theme_name = themes[theme_index][0]
	var theme_color = themes[theme_index][1]

	background.color = theme_color

	title_label.text = "ENGLISH ESCAPE ROOM"

	room_label.text = (
		theme_name
		+ "   •   LEVEL "
		+ str(level)
		+ " / 100"
	)

	puzzle_label.text = create_puzzle()

	result_label.text = "Choose the correct door to escape!"

	door_a.text = "🚪\nA"
	door_b.text = "🚪\nB"
	door_c.text = "🚪\nC"

	door_a.disabled = false
	door_b.disabled = false
	door_c.disabled = false

	door_a.show()
	door_b.show()
	door_c.show()


func create_puzzle() -> String:

	# Soru tipine göre döngüsel olarak farklı İngilizce konuları seçilir
	var puzzle_type = (level - 1) % 6

	match puzzle_type:
		0:
			# Subject / Object / Possessive Pronouns
			return """[ GRAMMAR: Pronouns ]
Fill in the blank with the correct option:

"This is not my key. I left ___ on the table, but Sarah couldn't find ___."

A) mine / it
B) my / them
C) me / its"""

		1:
			# Conditionals (Type 1 / Type 2)
			return """[ GRAMMAR: Conditionals ]
Which sentence is grammatically correct to complete the thought?

"If we had enough time right now, we ___ the secret passage."

A) will explore
B) would explore
C) explored"""

		2:
			# Present Perfect vs Simple Past
			return """[ GRAMMAR: Tenses ]
Choose the correct option:

"Look at the door! Someone ___ the lock, so we can't open it now. They ___ it yesterday."

A) has broken / broke
B) broke / has broken
C) breaks / break"""

		3:
			# Modals (Must / Should / Can't / Might)
			return """[ GRAMMAR: Modal Verbs ]
Solve the clue:

"The door is made of solid steel and has three locks. You ___ be able to break it with your bare hands!"

A) must
B) can't
C) should"""

		4:
			# Vocabulary (Environment / Travel / Mysteries)
			return """[ VOCABULARY: Definitions ]
Find the word that matches the definition:

"A piece of information or evidence that helps you solve a mystery, puzzle, or crime."

A) Clue
B) Trap
C) Obstacle"""

		5:
			# Relative Clauses (Who / Which / Where)
			return """[ GRAMMAR: Relative Clauses ]
Select the correct relative pronoun:

"This is the ancient room ___ the old clockmaker kept all his secret maps."

A) who
B) which
C) where"""

	return ""


func choose_door(door: int):

	if locked:
		return

	# Soruların doğru şıkları
	var puzzle_type = (level - 1) % 6
	var correct_door_index := 0

	match puzzle_type:
		0: correct_door_index = 0 # A (mine / it)
		1: correct_door_index = 1 # B (would explore)
		2: correct_door_index = 0 # A (has broken / broke)
		3: correct_door_index = 1 # B (can't)
		4: correct_door_index = 0 # A (Clue)
		5: correct_door_index = 2 # C (where)

	if door == correct_door_index:
		correct_door()
	else:
		wrong_door()


func correct_door():

	locked = true

	result_label.text = "✓ CORRECT! Opening the door..."

	door_a.disabled = true
	door_b.disabled = true
	door_c.disabled = true

	await get_tree().create_timer(1.2).timeout

	level += 1

	start_level()


func wrong_door():

	result_label.text = "✗ LOCKED! Read the clues carefully."


func finish_game():

	locked = true

	background.color = Color("#171717")

	title_label.text = "ESCAPE ROOM"

	room_label.text = "GAME COMPLETED!"

	puzzle_panel.hide()

	door_a.hide()
	door_b.hide()
	door_c.hide()

	result_label.text = """
🏆 ALL 100 LEVELS COMPLETED!

You answered all English grammar & vocabulary puzzles correctly.
You are free!
"""
