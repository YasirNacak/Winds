#include "ScriptingInterface.h"

ScriptingInterface *ScriptingInterface::m_instance = nullptr;

ScriptingInterface::ScriptingInterface() {

}

ScriptingInterface::~ScriptingInterface() {
	if (m_instance != nullptr) {
		delete m_instance;
	}
}

ScriptingInterface *ScriptingInterface::Get() {
	if (m_instance == nullptr) {
		m_instance = new ScriptingInterface();
	}

	return m_instance;
}

void ScriptingInterface::Initialize() {
	m_exported_functions.clear();

	m_exported_functions.push_back({ "NativePrint", this->NativePrint });
	m_exported_functions.push_back({ "NativeExit", this->NativeExit });
	m_exported_functions.push_back({ "NativeSetWindowTitle", this->NativeSetWindowTitle });
	m_exported_functions.push_back({ "NativeGetWindowWidth", this->NativeGetWindowWidth });
	m_exported_functions.push_back({ "NativeGetWindowHeight", this->NativeGetWindowHeight });
	m_exported_functions.push_back({ "NativeLoadSprite", this->NativeLoadSprite });
	m_exported_functions.push_back({ "NativeGetSpriteWidth", this->NativeGetSpriteWidth });
	m_exported_functions.push_back({ "NativeGetSpriteHeight", this->NativeGetSpriteHeight });
	m_exported_functions.push_back({ "NativeLoadFont", this->NativeLoadFont });
	m_exported_functions.push_back({ "NativeGetTextWidth", this->NativeGetTextWidth });
	m_exported_functions.push_back({ "NativeGetTextHeight", this->NativeGetTextHeight });
	m_exported_functions.push_back({ "NativeRenderUISprite", this->NativeRenderUISprite });
	m_exported_functions.push_back({ "NativeRenderUIText", this->NativeRenderUIText });
	m_exported_functions.push_back({ "NativeRenderSprite", this->NativeRenderSprite });
	m_exported_functions.push_back({ "NativeGetMousePosition", this->NativeGetMousePosition });
	m_exported_functions.push_back({ "NativeIsClickingPosition", this->NativeIsClickingPosition });
	m_exported_functions.push_back({ "NativeIsClicking", this->NativeIsClicking });
	m_exported_functions.push_back({ "NativeIsRightClicking", this->NativeIsRightClicking });
	m_exported_functions.push_back({ "NativeIsHoveringPosition", this->NativeIsHoveringPosition });
	m_exported_functions.push_back({ "NativeIsScrollingPosition", this->NativeIsScrollingPosition });
	m_exported_functions.push_back({ "NativeGetScrollDirection", this->NativeGetScrollDirection });
	m_exported_functions.push_back({ "NativeGetCurrentInputCharacter", this->NativeGetCurrentInputCharacter });
	m_exported_functions.push_back({ "NativeIsBackspaceInputGiven", this->NativeIsBackspaceInputGiven });
	m_exported_functions.push_back({ "NativeIsKeyDown", this->NativeIsKeyDown });
	m_exported_functions.push_back({ "NativeCreateRenderGroup", this->NativeCreateRenderGroup });
}

void ScriptingInterface::Bind(lua_State * lua) {
	for (int i = 0; i < m_exported_functions.size(); i++) {
		lua_pushcfunction(lua, m_exported_functions[i].function);
		lua_setglobal(lua, m_exported_functions[i].name);
	}
}

EXPORTED_DEFINITION(NativePrint) {
	// Get parameter
	const char *str = lua_tostring(lua, -1);
	std::cout << "[lua] " << str << std::endl;

	return 0;
}

EXPORTED_DEFINITION(NativeExit) {
	InputManager::Get()->SetExitInputGiven(true);
	return 0;
}

EXPORTED_DEFINITION(NativeSetWindowTitle) {
	const char *title = lua_tostring(lua, -1);

	RenderManager::Get()->SetWindowTitle(title);

	return 0;
}

EXPORTED_DEFINITION(NativeGetWindowWidth) {
	int window_width = RenderManager::Get()->GetWindowWidth();
	lua_pushinteger(lua, window_width);

	return 1;
}

EXPORTED_DEFINITION(NativeGetWindowHeight) {
	int window_height = RenderManager::Get()->GetWindowHeight();
	lua_pushinteger(lua, window_height);

	return 1;
}

EXPORTED_DEFINITION(NativeLoadSprite) {
	const char *sprite_path = lua_tostring(lua, -1);

	RenderManager::Get()->LoadSprite(sprite_path);

	return 0;
}

EXPORTED_DEFINITION(NativeGetSpriteWidth) {
	const char *sprite_path = lua_tostring(lua, -1);

	int result = RenderManager::Get()->GetSpriteWidth(sprite_path);

	lua_pushinteger(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeGetSpriteHeight) {
	const char *sprite_path = lua_tostring(lua, -1);

	int result = RenderManager::Get()->GetSpriteHeight(sprite_path);

	lua_pushinteger(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeLoadFont) {
	// Get parameters
	const char *font_path = lua_tostring(lua, -2);
	int font_size = (int) lua_tointeger(lua, -1);

	RenderManager::Get()->LoadFont(font_path, font_size);

	return 0;
}

EXPORTED_DEFINITION(NativeGetTextWidth) {
	// Get parameters
	const char *font_path = lua_tostring(lua, -3);
	int font_size = (int)lua_tointeger(lua, -2);
	const char *text = lua_tostring(lua, -1);

	int result = RenderManager::Get()->GetTextWidth(font_path, font_size, text);

	lua_pushinteger(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeGetTextHeight) {
	// Get parameters
	const char *font_path = lua_tostring(lua, -3);
	int font_size = (int)lua_tointeger(lua, -2);
	const char *text = lua_tostring(lua, -1);

	int result = RenderManager::Get()->GetTextHeight(font_path, font_size, text);

	lua_pushinteger(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeRenderUISprite) {
	// Get parameters
	const char *sprite_name = lua_tostring(lua, -5);
	double pos_x = (double) lua_tonumber(lua, -4);
	double pos_y = (double) lua_tonumber(lua, -3);
	Alignment alignment = (Alignment)lua_tointeger(lua, -2);
	int render_group_index = (int) lua_tointeger(lua, -1);

	RenderManager::Get()->RequestRender(sprite_name, pos_x, pos_y, alignment, render_group_index);

	return 0;
}

EXPORTED_DEFINITION(NativeRenderUIText) {
	// Get parameters
	const char *font_name = lua_tostring(lua, -10);
	const char *text = lua_tostring(lua, -9);
	double pos_x = (double) lua_tonumber(lua, -8);
	double pos_y = (double) lua_tonumber(lua, -7);
	int font_size = (int) lua_tointeger(lua, -6);
	int col_r = (int) lua_tointeger(lua, -5);
	int col_g = (int) lua_tointeger(lua, -4);
	int col_b = (int) lua_tointeger(lua, -3);
	Alignment alignment = (Alignment)lua_tointeger(lua, -2);
	int render_group_index = (int) lua_tointeger(lua, -1);

	RenderManager::Get()->RequestRender(font_name, text, pos_x, pos_y, font_size, col_r, col_g, col_b, alignment, render_group_index);

	return 0;
}

EXPORTED_DEFINITION(NativeRenderSprite) {
	// Get parameters
	const char *sprite_name = lua_tostring(lua, -4);
	double pos_x = (double)lua_tonumber(lua, -3);
	double pos_y = (double)lua_tonumber(lua, -2);
	int layer = (int)lua_tointeger(lua, -1);

	RenderManager::Get()->RequestRender(sprite_name, pos_x, pos_y, layer);

	return 0;
}

EXPORTED_DEFINITION(NativeGetMousePosition) {
	int mouse_x;
	int mouse_y;

	InputManager::Get()->GetMousePosition(&mouse_x, &mouse_y);

	lua_pushinteger(lua, mouse_x);
	lua_pushinteger(lua, mouse_y);

	return 2;
}

EXPORTED_DEFINITION(NativeIsClickingPosition) {
	// Get parameters
	const char *sprite_name = lua_tostring(lua, -4);
	double pos_x = (double) lua_tonumber(lua, -3);
	double pos_y = (double) lua_tonumber(lua, -2);
	Alignment alignment = (Alignment) lua_tointeger(lua, -1);

	// If not left-clicking, early return for performance gain
	if (!InputManager::Get()->IsMouseButtonInState(MouseButton::Left, InputState::Down)) {
		lua_pushboolean(lua, 0);
		return 0;
	}

	// Get size of the sprite
	int width = RenderManager::Get()->GetSpriteWidth(sprite_name);
	int height = RenderManager::Get()->GetSpriteHeight(sprite_name);

	// Get mouse position
	int mouse_pos_x;
	int mouse_pos_y;
	InputManager::Get()->GetMousePosition(&mouse_pos_x, &mouse_pos_y);

	switch (alignment) {
	case Alignment::TopLeft:
	case Alignment::MiddleLeft:
	case Alignment::BottomLeft:
		pos_x -= 0;
		break;
	case Alignment::TopCenter:
	case Alignment::MiddleCenter:
	case Alignment::BottomCenter:
		pos_x -= width / 2;
		break;
	case Alignment::TopRight:
	case Alignment::MiddleRight:
	case Alignment::BottomRight:
		pos_x -= width;
		break;
	default:
		break;
	}

	switch (alignment) {
	case Alignment::TopLeft:
	case Alignment::TopCenter:
	case Alignment::TopRight:
		pos_y -= 0;
		break;
	case Alignment::MiddleLeft:
	case Alignment::MiddleCenter:
	case Alignment::MiddleRight:
		pos_y -= height / 2;
		break;
	case Alignment::BottomLeft:
	case Alignment::BottomCenter:
	case Alignment::BottomRight:
		pos_y -= height;
		break;
	default:
		break;
	}

	// Check if mouse position is in boundaries of sprite
	bool is_in_w = mouse_pos_x >= pos_x && mouse_pos_x <= pos_x + width;
	bool is_in_h = mouse_pos_y >= pos_y && mouse_pos_y <= pos_y + height;

	bool result = is_in_w && is_in_h;

	// Return result back to caller
	lua_pushboolean(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeIsClicking) {
	bool result = InputManager::Get()->IsMouseButtonInState(MouseButton::Left, InputState::Down);

	// Return result back to caller
	lua_pushboolean(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeIsRightClicking) {
	bool result = InputManager::Get()->IsMouseButtonInState(MouseButton::Right, InputState::Down);

	// Return result back to caller
	lua_pushboolean(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeIsHoveringPosition) {
	// Get parameters
	const char *sprite_name = lua_tostring(lua, -4);
	double pos_x = (double)lua_tonumber(lua, -3);
	double pos_y = (double)lua_tonumber(lua, -2);
	Alignment alignment = (Alignment) lua_tointeger(lua, -1);

	// Get size of the sprite
	int width = RenderManager::Get()->GetSpriteWidth(sprite_name);
	int height = RenderManager::Get()->GetSpriteHeight(sprite_name);

	// Get mouse position
	int mouse_pos_x;
	int mouse_pos_y;
	InputManager::Get()->GetMousePosition(&mouse_pos_x, &mouse_pos_y);

	switch (alignment) {
	case Alignment::TopLeft:
	case Alignment::MiddleLeft:
	case Alignment::BottomLeft:
		pos_x -= 0;
		break;
	case Alignment::TopCenter:
	case Alignment::MiddleCenter:
	case Alignment::BottomCenter:
		pos_x -= width / 2;
		break;
	case Alignment::TopRight:
	case Alignment::MiddleRight:
	case Alignment::BottomRight:
		pos_x -= width;
		break;
	default:
		break;
	}
	
	switch (alignment) {
	case Alignment::TopLeft:
	case Alignment::TopCenter:
	case Alignment::TopRight:
		pos_y -= 0;
		break;
	case Alignment::MiddleLeft:
	case Alignment::MiddleCenter:
	case Alignment::MiddleRight:
		pos_y -= height / 2;
		break;
	case Alignment::BottomLeft:
	case Alignment::BottomCenter:
	case Alignment::BottomRight:
		pos_y -= height;
		break;
	default:
		break;
	}

	// Check if mouse position is in boundaries of sprite
	bool is_in_w = mouse_pos_x >= pos_x && mouse_pos_x <= pos_x + width;
	bool is_in_h = mouse_pos_y >= pos_y && mouse_pos_y <= pos_y + height;

	bool result = is_in_w && is_in_h;

	lua_pushboolean(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeIsScrollingPosition) {
	// Get parameters
	int width = (int) lua_tointeger(lua, -5);
	int height = (int) lua_tointeger(lua, -4);
	double pos_x = (double) lua_tonumber(lua, -3);
	double pos_y = (double) lua_tonumber(lua, -2);
	Alignment alignment = (Alignment)lua_tointeger(lua, -1);

	// If not left-clicking, early return for performance gain
	if (!InputManager::Get()->IsScrolling()) {
		lua_pushboolean(lua, 0);
		return 0;
	}

	// Get mouse position
	int mouse_pos_x;
	int mouse_pos_y;
	InputManager::Get()->GetMousePosition(&mouse_pos_x, &mouse_pos_y);

	switch (alignment) {
	case Alignment::TopLeft:
	case Alignment::MiddleLeft:
	case Alignment::BottomLeft:
		pos_x -= 0;
		break;
	case Alignment::TopCenter:
	case Alignment::MiddleCenter:
	case Alignment::BottomCenter:
		pos_x -= width / 2;
		break;
	case Alignment::TopRight:
	case Alignment::MiddleRight:
	case Alignment::BottomRight:
		pos_x -= width;
		break;
	default:
		break;
	}

	switch (alignment) {
	case Alignment::TopLeft:
	case Alignment::TopCenter:
	case Alignment::TopRight:
		pos_y -= 0;
		break;
	case Alignment::MiddleLeft:
	case Alignment::MiddleCenter:
	case Alignment::MiddleRight:
		pos_y -= height / 2;
		break;
	case Alignment::BottomLeft:
	case Alignment::BottomCenter:
	case Alignment::BottomRight:
		pos_y -= height;
		break;
	default:
		break;
	}

	// Check if mouse position is in boundaries of sprite
	bool is_in_w = mouse_pos_x >= pos_x && mouse_pos_x <= pos_x + width;
	bool is_in_h = mouse_pos_y >= pos_y && mouse_pos_y <= pos_y + height;

	bool result = is_in_w && is_in_h;

	// Return result back to caller
	lua_pushboolean(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeGetScrollDirection) {
	ScrollDirection result = InputManager::Get()->GetScrollDirection();
	lua_pushinteger(lua, result);
	return 1;
}

EXPORTED_DEFINITION(NativeGetCurrentInputCharacter) {
	char current_text_buffer = InputManager::Get()->GetCurrentTextBuffer();

	std::string result = "";

	if (current_text_buffer != NULL) {
		result += current_text_buffer;
	}

	lua_pushstring(lua, result.c_str());

	return 1;
}

EXPORTED_DEFINITION(NativeIsBackspaceInputGiven) {
	bool result = InputManager::Get()->IsBackspaceInputGiven();

	lua_pushboolean(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeIsKeyDown) {
	bool result = InputManager::Get()->IsKeyInState(std::string(lua_tostring(lua, -1)), InputState::Down);

	lua_pushboolean(lua, result);

	return 1;
}

EXPORTED_DEFINITION(NativeCreateRenderGroup) {
	double width = (double) lua_tonumber(lua, -4);
	double height = (double) lua_tonumber(lua, -3);
	double pos_x = (double) lua_tonumber(lua, -2);
	double pos_y = (double) lua_tonumber(lua, -1);

	int result = RenderManager::Get()->CreateRenderGroup(width, height, pos_x, pos_y);

	lua_pushinteger(lua, result);

	return 1;
}