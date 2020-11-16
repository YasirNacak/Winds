#pragma once

#include <iostream>
#include <fstream>
#include <string>
#include <map>

class EngineConfiguration {
private:
	EngineConfiguration();
	~EngineConfiguration();

public:
	static EngineConfiguration *Get();
	void Initialize(std::string config_file_path);
	int GetIntValue(const char *key);
	std::string GetStringValue(const char *key);
	bool GetBoolValue(const char *key);

private:
	void ReadConfigurationFile();

private:
	static EngineConfiguration *m_instance;
	bool m_is_initialized;
	std::string m_config_file_path;
	std::map<std::string, int> m_int_values;
	std::map<std::string, std::string> m_string_values;
	std::map<std::string, bool> m_bool_values;
};

