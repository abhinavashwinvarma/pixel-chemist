extends CanvasLayer

@onready var salt_desk: TextureButton = $SaltDesk
@onready var extractor: TextureButton = $Extractor
@onready var bookshelf: TextureButton = $Bookshelf
@onready var burner: TextureButton = $Burner
@onready var acid_table: TextureButton = $AcidTable
@onready var report_desk: TextureButton = $ReportDesk
@onready var thing_label: Label = $ThingLabel

signal salt_opened
signal extractor_opened
signal burner_opened
signal guides_opened
signal report_opened
signal acid_desk_opened

func _ready() -> void:
	salt_desk.disabled = false
	extractor.disabled = false
	bookshelf.disabled = false
	burner.disabled = false
	acid_table.disabled = false
	report_desk.disabled = false

func _process(_delta: float) -> void:
	
	if not Manager.can_use_machines:
		salt_desk.disabled = true
		extractor.disabled = true
		bookshelf.disabled = true
		burner.disabled = true
		acid_table.disabled = true
		report_desk.disabled = true
		thing_label.text = ''

		
	else:
		salt_desk.disabled = false
		extractor.disabled = false
		bookshelf.disabled = false
		burner.disabled = false
		acid_table.disabled = false
		report_desk.disabled = false

func _on_salt_desk_pressed() -> void:
	
	Manager.can_use_machines = false
	salt_opened.emit()

func _on_extractor_pressed() -> void:
	
	Manager.can_use_machines = false
	extractor_opened.emit()

func _on_burner_pressed() -> void:
	
	Manager.can_use_machines = false
	burner_opened.emit()

func _on_bookshelf_pressed() -> void:
	Manager.can_use_machines = false
	guides_opened.emit()

func _on_report_desk_pressed() -> void:
	Manager.can_use_machines = false
	report_opened.emit()

func _on_extractor_mouse_entered() -> void:
	thing_label.text = 'Extractor'

func _on_salt_desk_mouse_entered() -> void:
	thing_label.text = 'Salt Desk'
	
func _on_bookshelf_mouse_entered() -> void:
	thing_label.text = 'Bookshelf'
	
func _on_burner_mouse_entered() -> void:
	thing_label.text = 'Burner'

func _on_acid_table_mouse_entered() -> void:
	thing_label.text = 'Workbench'

func _on_report_desk_mouse_entered() -> void:
	thing_label.text = 'Report Desk'

func _on_salt_desk_mouse_exited() -> void:
	thing_label.text = ''

func _on_extractor_mouse_exited() -> void:
	thing_label.text = ''

func _on_bookshelf_mouse_exited() -> void:
	thing_label.text = ''

func _on_burner_mouse_exited() -> void:
	thing_label.text = ''

func _on_acid_table_mouse_exited() -> void:
	thing_label.text = ''

func _on_report_desk_mouse_exited() -> void:
	thing_label.text = ''

func _on_acid_table_pressed() -> void:
	acid_desk_opened.emit()
