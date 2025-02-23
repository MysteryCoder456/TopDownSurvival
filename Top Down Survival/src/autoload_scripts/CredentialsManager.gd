extends Node

const CREDS_FILE = "user://credentials.json"


func _ready():
	var file = File.new()
	if not file.file_exists(CREDS_FILE):
		save_credentials("", "")


func _get_encryption_key() -> PoolByteArray:
	var key = OS.get_name() + OS.get_unique_id() + OS.get_locale_language()
	return key.sha256_buffer().subarray(0, 31)  # First 32 elements


func get_credentials() -> Dictionary:
	var key = _get_encryption_key()
	var file = File.new()
	file.open_encrypted(CREDS_FILE, File.READ, key)
	var creds = JSON.parse(file.get_as_text()).get_result()

	if not creds:
		return {
			"email": "",
			"password": "",
		}
	return creds


func save_credentials(email: String, password: String):
	var key = _get_encryption_key()
	var creds = {"email": email, "password": password}

	var file = File.new()
	file.open_encrypted(CREDS_FILE, File.WRITE, key)
	file.store_string(to_json(creds))
	file.close()
