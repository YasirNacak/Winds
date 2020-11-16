#pragma once
#include <cassert>

#include <iostream>
#include <vector>
#include <map>
#include <algorithm>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>

enum Alignment {
	TopLeft = 0,
	TopCenter = 1,
	TopRight = 2,
	MiddleLeft = 3,
	MiddleCenter = 4,
	MiddleRight = 5,
	BottomLeft = 6,
	BottomCenter = 7,
	BottomRight = 9,
};

struct RenderGroup {
	SDL_Texture *texture;
	double width;
	double height;
	double pos_x;
	double pos_y;
};

struct Sprite {
	std::string path;
	SDL_Texture *texture;
	int width;
	int height;
};

struct Font {
	std::string path;
	TTF_Font *font;
	int size;
};

struct RenderQueueUIElement {
	double pos_x;
	double pos_y;
	Alignment alignment;
	int render_group_index;
};

struct RenderQueueElement {
	double pos_x;
	double pos_y;
	int layer;

	inline bool operator < (const RenderQueueElement& element) {
		return layer < element.layer;
	}
};

struct RenderQueueUISpriteElement : RenderQueueUIElement {
	std::string sprite_path;
};

struct RenderQueueUITextElement : RenderQueueUIElement {
	std::string font_path;
	std::string text;
	int size;
	int col_r;
	int col_g;
	int col_b;
};

struct RenderQueueSpriteElement : RenderQueueElement {
	std::string sprite_path;
};

class RenderManager {
private:
	RenderManager();
	~RenderManager();

public:
	static RenderManager *Get();
	void Initialize(int window_width, int window_height, bool is_fullscreen);
	int GetWindowWidth();
	int GetWindowHeight();
	int CreateRenderGroup(double width, double height, double pos_x, double pos_y);
	void LoadSprite(const char *sprite_path);
	void LoadFont(const char *font_path, int font_size);
	void SetWindowTitle(const char *title);
	void Render();
	void RequestRender(const char *sprite_path, double pos_x, double pos_y, Alignment alignment, int render_group_index);
	void RequestRender(const char *font_path, const char *text, double pos_x, double pos_y, int font_size, int col_r, int col_g, int col_b, Alignment alignment, int render_group_index);
	void RequestRender(const char *sprite_path, double pos_x, double pos_y, int layer);
	int GetSpriteWidth(const char *sprite_name);
	int GetSpriteHeight(const char *sprite_name);
	int GetTextWidth(const char *font_name, int font_size, const char *text);
	int GetTextHeight(const char *font_name, int font_size, const char *text);

private:
	static RenderManager *m_instance;
	bool m_is_initialized;
	SDL_Window *m_window;
	SDL_Renderer *m_renderer;
	int m_window_width;
	int m_window_height;
	std::map<std::string, Sprite> m_sprites;
	std::vector<Font> m_fonts;
	SDL_Texture *m_sprite_render_texture;
	std::vector<std::vector<RenderQueueUISpriteElement>> m_ui_sprite_render_queue;
	std::vector<std::vector<RenderQueueUITextElement>> m_ui_text_render_queue;
	std::vector<RenderQueueSpriteElement> m_sprite_render_queue;
	std::vector<RenderGroup> m_render_groups;
};
