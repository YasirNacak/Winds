#include <Windows.h>

#include <iostream>
#include <fstream>
#include <cstring>
#include <chrono>

#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <Lua/lua.hpp>

#include "RenderManager.h"
#include "InputManager.h"
#include "ScriptingInterface.h"
#include "EngineConfiguration.h"

std::string ENGINE_CONFIG_LOCATION = "..\\..\\Config\\WindsConfig.txt";

int main(int argc, char * argv[]) {
	// Initialize SDL
	int sdl_init_result = SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_AUDIO);
	int ttf_init_result = TTF_Init();

	if (sdl_init_result) {
		std::cerr << "Error initializing SDL." << std::endl;
		return -1;
	}

	if (ttf_init_result) {
		std::cerr << "Error initializing TTF." << std::endl;
		return -1;
	}

	// Initialize configuration and set values
	EngineConfiguration::Get()->Initialize(ENGINE_CONFIG_LOCATION);
	std::string game_code_path = EngineConfiguration::Get()->GetStringValue("GameCodePath");
	int window_width = EngineConfiguration::Get()->GetIntValue("WindowWidth");
	int window_height = EngineConfiguration::Get()->GetIntValue("WindowHeight");
	bool is_fullscreen = EngineConfiguration::Get()->GetBoolValue("IsFullScreen");

	// Initialize subsystems
	RenderManager::Get()->Initialize(window_width, window_height, is_fullscreen);
	InputManager::Get()->Initialize();

	// Load game code
	lua_State *lua = luaL_newstate();
	luaL_openlibs(lua);
	ScriptingInterface::Get()->Initialize();
	ScriptingInterface::Get()->Bind(lua);

	if (luaL_dofile(lua, game_code_path.c_str())) {
		const char *error_message = lua_tostring(lua, -1);
		std::cerr << "Error loading game code." << error_message << std::endl;
		return -1;
	}

	// An event is generated on sdl side that we need to handle
	SDL_Event event;

	// Update period is 60 times a second
	auto update_period = std::chrono::nanoseconds(16666666);
	std::chrono::steady_clock::time_point last_update_time = std::chrono::steady_clock::now();

	bool is_running = true;
	while (is_running) {
		std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
		auto time_passed = std::chrono::duration_cast<std::chrono::nanoseconds>(current_time - last_update_time);
		
		if (time_passed < update_period) {
			continue;
		}

		last_update_time = current_time;

		InputManager::Get()->Update();

		// Dispatch all events
		while (SDL_PollEvent(&event)) {
			// Send all events to input manager
			InputManager::Get()->HandleEvent(&event);
		}

		is_running = !InputManager::Get()->IsExitInputGiven();

		bool should_reload_game = InputManager::Get()->IsReloadGameInputGiven();
		bool should_reload_scene = InputManager::Get()->IsReloadSceneInputGiven();

		if (should_reload_game || should_reload_scene) {
			char current_scene_name[64];
			if (should_reload_scene) {
				lua_getglobal(lua, "GetCurrentSceneName");
				lua_pcall(lua, 0, 1, 0);
				strcpy_s(current_scene_name, lua_tostring(lua, -1));
			}

			lua_close(lua);

			lua = luaL_newstate();
			luaL_openlibs(lua);
			ScriptingInterface::Get()->Initialize();
			ScriptingInterface::Get()->Bind(lua);

			if (luaL_dofile(lua, game_code_path.c_str())) {
				const char *error_message = lua_tostring(lua, -1);
				std::cerr << "Error loading game code." << error_message << std::endl;
				return -1;
			}

			if (should_reload_scene && current_scene_name != nullptr) {
				lua_getglobal(lua, "SetScene");
				lua_pushstring(lua, current_scene_name);
				lua_pcall(lua, 1, 0, 0);
			}
		}
	
		// If engine side is not requested to exit, update game side
		if (is_running) {
			// Update game
			lua_getglobal(lua, "Update");
			auto update_result = lua_pcall(lua, 0, 0, 0);

			// Check for errors on the game side
			if (update_result != LUA_OK) {
				const char *error_message = lua_tostring(lua, -1);
				std::cout << "Error when updating game: " << error_message << std::endl;
				break;
			}
		}

		// Render
		RenderManager::Get()->Render();
	}

	// Close lua interface
	lua_close(lua);

	// Terminate SDL
	SDL_Quit();
	TTF_Quit();

	return 0;
}
