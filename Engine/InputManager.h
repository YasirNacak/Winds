#pragma once

#include <iostream>
#include <vector>
#include <map>
#include <SDL2/SDL.h>

enum InputState {
	Up,
	Down,
	On,
};

enum MouseButton {
	Left,
	Right,
	Middle,
};

enum ScrollDirection {
	WheelUp = 1,
	WheelDown = -1,
};

struct MouseButtonState {
	MouseButton button;
	InputState state;
};

class InputManager {
private:
	InputManager();
	~InputManager();

public:
	static InputManager *Get();
	void Initialize();
	void InitializeKeyboardInputs();
	void Update();
	void HandleEvent(SDL_Event *event);
	char GetCurrentTextBuffer();
	bool IsExitInputGiven();
	void SetExitInputGiven(bool exit_input_given);
	bool IsReloadGameInputGiven();
	bool IsReloadSceneInputGiven();
	bool IsBackspaceInputGiven();
	bool IsScrolling();
	ScrollDirection GetScrollDirection();
	bool IsMouseButtonInState(MouseButton button, InputState state);
	bool IsKeyInState(std::string key, InputState state);
	void GetMousePosition(int *ret_x, int *ret_y);

private:
	int GetMouseButtonIndex(SDL_Event *event);

private:
	static InputManager *m_instance;
	bool m_is_initialized;
	bool m_is_exit_input_given;
	bool m_is_reload_game_input_given;
	bool m_is_reload_scene_input_given;
	bool m_is_backspace_input_given;
	bool m_is_scrolling;
	ScrollDirection m_scroll_direction;
	std::vector<MouseButtonState> m_mouse_button_states;
	std::map<std::string, InputState> m_key_states;
	char m_current_text_buffer;
};

