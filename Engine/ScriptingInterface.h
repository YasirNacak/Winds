#pragma once
#include <vector>

#include <Lua/lua.hpp>
#include "RenderManager.h"
#include "InputManager.h"

#define EXPORTED(FUNCTION_NAME) static int FUNCTION_NAME(lua_State* lua)
#define EXPORTED_DEFINITION(FUNCTION_NAME) int ScriptingInterface::FUNCTION_NAME(lua_State* lua)

typedef int(*LuaFunction)(lua_State*);

struct ExportedFunction {
	const char name[128];
	LuaFunction function;
};

class ScriptingInterface {
private:
	ScriptingInterface();
	~ScriptingInterface();

public:
	static ScriptingInterface *Get();
	void Initialize();
	void Bind(lua_State *lua);

private:
	EXPORTED(NativePrint);
	EXPORTED(NativeExit);
	EXPORTED(NativeSetWindowTitle);
	EXPORTED(NativeGetWindowWidth);
	EXPORTED(NativeGetWindowHeight);
	EXPORTED(NativeLoadSprite);
	EXPORTED(NativeGetSpriteWidth);
	EXPORTED(NativeGetSpriteHeight);
	EXPORTED(NativeLoadFont);
	EXPORTED(NativeGetTextWidth);
	EXPORTED(NativeGetTextHeight);
	EXPORTED(NativeRenderUISprite);
	EXPORTED(NativeRenderUIText);
	EXPORTED(NativeRenderSprite);
	EXPORTED(NativeGetMousePosition);
	EXPORTED(NativeIsClicking);
	EXPORTED(NativeIsRightClicking);
	EXPORTED(NativeIsClickingPosition);
	EXPORTED(NativeIsHoveringPosition);
	EXPORTED(NativeIsScrollingPosition);
	EXPORTED(NativeGetScrollDirection);
	EXPORTED(NativeGetCurrentInputCharacter);
	EXPORTED(NativeIsBackspaceInputGiven);
	EXPORTED(NativeIsKeyDown);
	EXPORTED(NativeCreateRenderGroup);

private:
	static ScriptingInterface *m_instance;
	std::vector<ExportedFunction> m_exported_functions;
};

