#include "EngineConfiguration.h"

EngineConfiguration *EngineConfiguration::m_instance = nullptr;

EngineConfiguration::EngineConfiguration() {
	m_is_initialized = false;
}

EngineConfiguration::~EngineConfiguration() {
	if (m_is_initialized) {

	}
}

EngineConfiguration *EngineConfiguration::Get() {
	if (m_instance == nullptr) {
		m_instance = new EngineConfiguration();
	}

	return m_instance;
}

void EngineConfiguration::Initialize(std::string config_file_path) {
	m_config_file_path = std::string(config_file_path);

	ReadConfigurationFile();

	m_is_initialized = true;
}

int EngineConfiguration::GetIntValue(const char *key) {
	return m_int_values[key];
}

std::string EngineConfiguration::GetStringValue(const char *key) {
	return m_string_values[key];
}

bool EngineConfiguration::GetBoolValue(const char * key){
	return m_bool_values[key];
}

void EngineConfiguration::ReadConfigurationFile() {
	auto config_stream = std::ifstream(m_config_file_path);

	std::string type;
	std::string key;
	std::string value;

	while (config_stream >> type >> key >> value) {
		if (type == "int") {
			m_int_values[key] = std::atoi(value.c_str());
		}
		else if (type == "bool") {
			bool bool_value = false;
			if (value == "true") {
				bool_value = true;
			}
			else if (value == "false") {
				bool_value = false;
			}
			m_bool_values[key] = bool_value;
		}
		else if (type == "string") {
			m_string_values[key] = value;
		}
	}

	config_stream.close();
}
