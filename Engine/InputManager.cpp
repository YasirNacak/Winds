#include "InputManager.h"

InputManager *InputManager::m_instance = nullptr;

InputManager::InputManager() {
	m_is_initialized = false;
}

InputManager::~InputManager() {
	if (m_is_initialized) {
		delete m_instance;
	}
}

InputManager *InputManager::Get() {
	if (m_instance == nullptr) {
		m_instance = new InputManager();
	}

	return m_instance;
}

void InputManager::Initialize() {
	m_is_exit_input_given = false;
	m_is_reload_game_input_given = false;
	m_is_reload_scene_input_given = false;
	m_is_backspace_input_given = false;
	m_current_text_buffer = NULL;

	// Add initial mouse button states
	m_mouse_button_states.push_back({ MouseButton::Left, InputState::Up });
	m_mouse_button_states.push_back({ MouseButton::Right, InputState::Up });
	m_mouse_button_states.push_back({ MouseButton::Middle, InputState::Up });
	
	m_is_initialized = true;
}

void InputManager::InitializeKeyboardInputs() {
	m_key_states["UpArrow"] = InputState::Up;
	m_key_states["LeftArrow"] = InputState::Up;
	m_key_states["DownArrow"] = InputState::Up;
	m_key_states["RightArrow"] = InputState::Up;
}

void InputManager::Update() {
	m_is_reload_game_input_given = false;
	m_is_reload_scene_input_given = false;
	m_is_backspace_input_given = false;
	m_is_scrolling = false;
	m_current_text_buffer = NULL;

	for (auto &mouse_button_state : m_mouse_button_states) {
		if (mouse_button_state.state == InputState::Down) {
			mouse_button_state.state = InputState::On;
		}
	}

	for (auto &key_state : m_key_states) {
		if (key_state.second == InputState::Down) {
			key_state.second = InputState::On;
		}
	}
}

void InputManager::HandleEvent(SDL_Event *event) {
	if (event->type == SDL_KEYDOWN) {
		auto symbol = event->key.keysym.sym;
		if (symbol == SDLK_ESCAPE) {
			m_is_exit_input_given = true;
		}
		else if (symbol == SDLK_F5) {
			m_is_reload_scene_input_given = true;
		}
		else if (symbol == SDLK_F6) {
			m_is_reload_game_input_given = true;
		}
		else if (symbol == SDLK_BACKSPACE) {
			m_is_backspace_input_given = true;
		}
		
		// Get characters
		if ((symbol >= '0' && symbol <= '9') ||
			(symbol >= 'A' && symbol <= 'Z') ||
			(symbol >= 'a' && symbol <= 'z') ||
			symbol == SDLK_SPACE) {
			m_current_text_buffer = (char) symbol;
		}

		if (symbol == SDLK_UP) {
			m_key_states["UpArrow"] = InputState::Down;
		}
		else if (symbol == SDLK_LEFT) {
			m_key_states["LeftArrow"] = InputState::Down;
		}
		else if (symbol == SDLK_DOWN) {
			m_key_states["DownArrow"] = InputState::Down;
		}
		else if (symbol == SDLK_RIGHT) {
			m_key_states["RightArrow"] = InputState::Down;
		}
	}
	else if (event->type == SDL_KEYDOWN) {
		auto symbol = event->key.keysym.sym;
		if (symbol == SDLK_UP) {
			m_key_states["UpArrow"] = InputState::Up;
		}
		else if (symbol == SDLK_LEFT) {
			m_key_states["LeftArrow"] = InputState::Up;
		}
		else if (symbol == SDLK_DOWN) {
			m_key_states["DownArrow"] = InputState::Up;
		}
		else if (symbol == SDLK_RIGHT) {
			m_key_states["RightArrow"] = InputState::Up;
		}
	}
	else if (event->type == SDL_MOUSEBUTTONDOWN) {
		int button_index = GetMouseButtonIndex(event);
		
		// If click started, switch from any state to Down state
		m_mouse_button_states[button_index].state = InputState::Down;
	}
	else if (event->type == SDL_MOUSEBUTTONUP) {
		int button_index = GetMouseButtonIndex(event);

		// If not clicking anymore, switch from any state to Up state
		m_mouse_button_states[button_index].state = InputState::Up;
	}
	else if (event->type == SDL_MOUSEWHEEL) {
		if (event->wheel.y > 0) {
			m_is_scrolling = true;
			m_scroll_direction = ScrollDirection::WheelUp;
		}
		else if (event->wheel.y < 0) {
			m_is_scrolling = true;
			m_scroll_direction = ScrollDirection::WheelDown;
		}
	}
}

char InputManager::GetCurrentTextBuffer() {
	return m_current_text_buffer;
}

bool InputManager::IsExitInputGiven() {
	return m_is_exit_input_given;
}

void InputManager::SetExitInputGiven(bool exit_input_given) {
	m_is_exit_input_given = exit_input_given;
}

bool InputManager::IsReloadGameInputGiven() {
	return m_is_reload_game_input_given;
}

bool InputManager::IsReloadSceneInputGiven() {
	return m_is_reload_scene_input_given;
}

bool InputManager::IsBackspaceInputGiven() {
	return m_is_backspace_input_given;
}

bool InputManager::IsScrolling() {
	return m_is_scrolling;
}

ScrollDirection InputManager::GetScrollDirection() {
	return m_scroll_direction;
}

bool InputManager::IsMouseButtonInState(MouseButton button, InputState state) {
	return m_mouse_button_states[button].state == state;
}

bool InputManager::IsKeyInState(std::string key, InputState state) {
	return m_key_states[key] == state;
}

void InputManager::GetMousePosition(int *ret_x, int *ret_y) {
	SDL_GetMouseState(ret_x, ret_y);
}

int InputManager::GetMouseButtonIndex(SDL_Event *event) {
	if (event->button.button == SDL_BUTTON_LEFT) {
		return MouseButton::Left;
	}
	else if (event->button.button == SDL_BUTTON_RIGHT) {
		return MouseButton::Right;
	}
	else if (event->button.button == SDL_BUTTON_MIDDLE) {
		return MouseButton::Middle;
	}
	
	// By default, return left button
	return 0;
}
