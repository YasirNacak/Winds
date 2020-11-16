#include "RenderManager.h"

RenderManager *RenderManager::m_instance = nullptr;

RenderManager::RenderManager() {
	m_is_initialized = false;
}

RenderManager::~RenderManager() {
	if (m_is_initialized && m_instance != nullptr) {
		delete m_instance;
		
		for (auto sprite : m_sprites) {
			SDL_DestroyTexture(sprite.second.texture);
		}

		for (auto font : m_fonts) {
			TTF_CloseFont(font.font);
		}

		for (auto group : m_render_groups) {
			SDL_DestroyTexture(group.texture);
		}

		SDL_DestroyRenderer(m_renderer);
		SDL_DestroyWindow(m_window);
	}
}

RenderManager *RenderManager::Get() {
	if (m_instance == nullptr) {
		m_instance = new RenderManager();
	}

	return m_instance;
}

void RenderManager::Initialize(int window_width, int window_height, bool is_fullscreen) {
	assert(!m_is_initialized);

	m_window_width = window_width;
	m_window_height = window_height;

	// Initialize SDL window and a renderer on that window
	m_window = SDL_CreateWindow("", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, m_window_width, m_window_height, SDL_WINDOW_OPENGL);
	m_renderer = SDL_CreateRenderer(m_window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_TARGETTEXTURE);

	// Check if window and renderer have created successfully
	if (m_window == NULL || m_renderer == NULL) {
		std::cerr << "Initialization failed." << std::endl;
	}

	if (is_fullscreen) {
		SDL_SetWindowFullscreen(m_window, SDL_WINDOW_FULLSCREEN);
	}

	// Create initial render group
	int initial_group_index = this->CreateRenderGroup(window_width, window_height, 0, 0);

	if (initial_group_index != 0) {
		std::cerr << "Can't create default render group twice!" << std::endl;

		return;
	}

	// Create sprite render target texture
	m_sprite_render_texture = SDL_CreateTexture(m_renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, m_window_width, m_window_height);

	m_is_initialized = true;
}

int RenderManager::GetWindowWidth() {
	return m_window_width;
}

int RenderManager::GetWindowHeight() {
	return m_window_height;
}

int RenderManager::CreateRenderGroup(double width, double height, double pos_x, double pos_y) {
	if (m_render_groups.size() > 0) {
		assert(m_is_initialized);
	}

	SDL_Texture *texture = SDL_CreateTexture(m_renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, m_window_width, m_window_height);
	RenderGroup group = { texture, width, height, pos_x, pos_y };
	std::vector<RenderQueueUISpriteElement> group_sprite_queue;
	std::vector<RenderQueueUITextElement> group_text_queue;
	m_ui_sprite_render_queue.push_back(group_sprite_queue);
	m_ui_text_render_queue.push_back(group_text_queue);
	m_render_groups.push_back(group);
	return m_render_groups.size() - 1;
}

void RenderManager::LoadSprite(const char* sprite_path) {
	assert(m_is_initialized);

	// Dont reload if it already exists
	if (m_sprites.find(std::string(sprite_path)) != m_sprites.end()) {
		return;
	}

	std::string full_sprite_path = "..\\..\\" + std::string(sprite_path);
	SDL_Texture *texture = IMG_LoadTexture(m_renderer, full_sprite_path.c_str());

	if (texture == NULL) {
		std::cerr << "Sprite could not be loaded: " << sprite_path << std::endl;
	}
	else {
		std::cout << "Sprite Loaded: " << sprite_path << std::endl;
	}
	
	int width;
	int height;
	SDL_QueryTexture(texture, NULL, NULL, &width, &height);
	Sprite sprite_asset{ std::string(sprite_path), texture, width, height };
	m_sprites.emplace(std::string(sprite_path), sprite_asset);
}

void RenderManager::LoadFont(const char * font_path, int font_size) {
	assert(m_is_initialized);

	for (auto font : m_fonts) {
		if (font.path == std::string(font_path) && font.size == font_size) {
			return;
		}
	}

	std::string full_font_path = "..\\..\\" + std::string(font_path);
	TTF_Font *font = TTF_OpenFont(full_font_path.c_str(), font_size);

	if (font == NULL) {
		std::cerr << "Font could not be loaded: " << font_path << std::endl;
	}
	else {
		std::cout << "Font Loaded: " << font_path << ", Size: " << font_size << std::endl;
	}

	Font font_asset { std::string(font_path), font, font_size };
	m_fonts.push_back(font_asset);
}

void RenderManager::SetWindowTitle(const char * title) {
	assert(m_is_initialized);

	SDL_SetWindowTitle(m_window, title);
}

void RenderManager::Render() {
	assert(m_is_initialized);

	SDL_SetRenderTarget(m_renderer, NULL);
	SDL_RenderClear(m_renderer);

	for (int i = 0; i < m_render_groups.size(); i++) {
		SDL_SetRenderTarget(m_renderer, m_render_groups[i].texture);
		SDL_SetTextureBlendMode(m_render_groups[i].texture, SDL_BLENDMODE_BLEND);
		SDL_SetRenderDrawColor(m_renderer, 0, 0, 0, 0);
		SDL_RenderClear(m_renderer);
	}

	// Set as sprite render target and clear
	SDL_SetRenderTarget(m_renderer, m_sprite_render_texture);
	SDL_SetTextureBlendMode(m_sprite_render_texture, SDL_BLENDMODE_BLEND);
	SDL_SetRenderDrawColor(m_renderer, 0, 0, 0, 0);
	SDL_RenderClear(m_renderer);

	// Sort sprites by layer
	std::sort(m_sprite_render_queue.begin(), m_sprite_render_queue.end());

	// Create sprite to render
	Sprite *sprite_to_be_rendered = nullptr;
	int current_layer = 0;

	for (auto &element : m_sprite_render_queue) {
		// Cull out of screen sprites (doesnt work for ones with bigger sizes)
		if (element.pos_x < -100 || element.pos_x > m_window_width + 100) {
			continue;
		}

		if (element.pos_y < -100 || element.pos_y > m_window_height + 100) {
			continue;
		}

		if (sprite_to_be_rendered == nullptr || element.layer != current_layer) {
			if (m_sprites.find(element.sprite_path) != m_sprites.end()) {
				sprite_to_be_rendered = &m_sprites[element.sprite_path];
			}
		}

		if (sprite_to_be_rendered != nullptr) {
			SDL_Rect rect;
			rect.w = sprite_to_be_rendered->width;
			rect.h = sprite_to_be_rendered->height;
			rect.x = element.pos_x;
			rect.y = element.pos_y;

			SDL_RenderCopy(m_renderer, sprite_to_be_rendered->texture, NULL, &rect);
		}
	}

	m_sprite_render_queue.clear();
	
	// Render UI sprites
	for (int i = 0; i < m_ui_sprite_render_queue.size(); i++) {
		SDL_SetRenderTarget(m_renderer, m_render_groups[i].texture);

		for (auto render_element : m_ui_sprite_render_queue[i]) {
			Sprite *sprite_to_be_rendered = nullptr;

			if (m_sprites.find(render_element.sprite_path) != m_sprites.end()) {
				sprite_to_be_rendered = &m_sprites[render_element.sprite_path];
			}

			if (sprite_to_be_rendered != nullptr) {
				SDL_Rect rect;
				rect.w = sprite_to_be_rendered->width;
				rect.h = sprite_to_be_rendered->height;

				auto align = render_element.alignment;
				
				if (align == Alignment::TopLeft || align == Alignment::MiddleLeft || align == Alignment::BottomLeft) {
					rect.x = render_element.pos_x;
				}
				else if (align == Alignment::TopCenter || align == Alignment::MiddleCenter || align == Alignment::BottomCenter) {
					rect.x = render_element.pos_x - rect.w / 2;
				}
				else if (align == Alignment::TopRight || align == Alignment::MiddleRight || align == Alignment::BottomRight) {
					rect.x = render_element.pos_x - rect.w;
				}
			
				if (align == Alignment::TopLeft || align == Alignment::TopCenter || align == Alignment::TopRight) {
					rect.y = render_element.pos_y;
				}
				else if (align == Alignment::MiddleLeft || align == Alignment::MiddleCenter || align == Alignment::MiddleRight) {
					rect.y = render_element.pos_y - rect.h / 2;
				}
				else if (align == Alignment::BottomLeft || align == Alignment::BottomCenter || align == Alignment::BottomRight) {
					rect.y = render_element.pos_y - rect.h;
				}

				SDL_RenderCopy(m_renderer, sprite_to_be_rendered->texture, NULL, &rect);
			}
		}

		m_ui_sprite_render_queue[i].clear();
	}

	// Render UI text
	for (int i = 0; i < m_ui_text_render_queue.size(); i++) {
		SDL_SetRenderTarget(m_renderer, m_render_groups[i].texture);

		for (auto render_element : m_ui_text_render_queue[i]) {
			Font *font_to_be_rendered = nullptr;

			for (auto font : m_fonts) {
				if (font.size == render_element.size && font.path == render_element.font_path) {
					font_to_be_rendered = &font;
					break;
				}
			}

			// TODO: (yasir) This can be heavily optimized
			if (font_to_be_rendered != nullptr) {
				SDL_Color text_color = {
					(uint8_t)render_element.col_r,
					(uint8_t)render_element.col_g,
					(uint8_t)render_element.col_b
				};

				SDL_Surface* surface = TTF_RenderText_Blended(font_to_be_rendered->font, render_element.text.c_str(), text_color);
				SDL_Texture* texture = SDL_CreateTextureFromSurface(m_renderer, surface);

				SDL_Rect rect;
				SDL_QueryTexture(texture, NULL, NULL, &rect.w, &rect.h);

				auto align = render_element.alignment;
				rect.x = render_element.pos_x;
				rect.y = render_element.pos_y;

				if (align == Alignment::TopLeft || align == Alignment::MiddleLeft || align == Alignment::BottomLeft) {
					rect.x = render_element.pos_x;
				}
				else if (align == Alignment::TopCenter || align == Alignment::MiddleCenter || align == Alignment::BottomCenter) {
					rect.x = render_element.pos_x - rect.w / 2;
				}
				else if (align == Alignment::TopRight || align == Alignment::MiddleRight || align == Alignment::BottomRight) {
					rect.x = render_element.pos_x - rect.w;
				}

				if (align == Alignment::TopLeft || align == Alignment::TopCenter || align == Alignment::TopRight) {
					rect.y = render_element.pos_y;
				}
				else if (align == Alignment::MiddleLeft || align == Alignment::MiddleCenter || align == Alignment::MiddleRight) {
					rect.y = render_element.pos_y - rect.h / 2;
				}
				else if (align == Alignment::BottomLeft || align == Alignment::BottomCenter || align == Alignment::BottomRight) {
					rect.y = render_element.pos_y - rect.h;
				}

				SDL_RenderCopy(m_renderer, texture, NULL, &rect);

				SDL_DestroyTexture(texture);
				SDL_FreeSurface(surface);
			}
		}

		m_ui_text_render_queue[i].clear();
	}


	// Combine groups into final render target
	
	// Copy sprites render texture
	SDL_SetRenderTarget(m_renderer, NULL);
	SDL_Rect window_rect{ 0, 0, m_window_width, m_window_height };
	SDL_RenderCopy(m_renderer, m_sprite_render_texture, NULL, &window_rect);

	// UI is rendered on top of other things
	for (auto& group : m_render_groups) {
		auto tex = SDL_CreateTexture(m_renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, group.width, group.height);
		SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);
		SDL_Rect clip_rect{ group.pos_x, group.pos_y, group.width, group.height };
		SDL_SetRenderTarget(m_renderer, tex);
		SDL_RenderCopy(m_renderer, group.texture, &clip_rect, NULL);

		SDL_SetRenderTarget(m_renderer, NULL);
		SDL_RenderCopy(m_renderer, tex, NULL, &clip_rect);

		SDL_DestroyTexture(tex);
	}

	// Present what has been rendered
	SDL_RenderPresent(m_renderer);
}

void RenderManager::RequestRender(const char * sprite_path, double pos_x, double pos_y, Alignment alignment, int render_group_index) {
	assert(m_is_initialized);

	if (std::string(sprite_path) == "") {
		return;
	}

	RenderQueueUISpriteElement element;
	element.pos_x = pos_x;
	element.pos_y = pos_y;
	element.sprite_path = std::string(sprite_path);
	element.alignment = alignment;
	element.render_group_index = render_group_index;
	m_ui_sprite_render_queue[render_group_index].push_back(element);
}

void RenderManager::RequestRender(const char * font_path, const char * text, double pos_x, double pos_y, int font_size, int col_r, int col_g, int col_b, Alignment alignment, int render_group_index) {
	assert(m_is_initialized);

	if (std::string(font_path) == "") {
		return;
	}

	RenderQueueUITextElement element;
	element.pos_x = pos_x;
	element.pos_y = pos_y;
	element.font_path = std::string(font_path);
	element.text = std::string(text);
	element.size = font_size;
	element.col_r = col_r;
	element.col_g = col_g;
	element.col_b = col_b;
	element.alignment = alignment;
	element.render_group_index = render_group_index;
	m_ui_text_render_queue[render_group_index].push_back(element);
}

void RenderManager::RequestRender(const char * sprite_path, double pos_x, double pos_y, int layer) {
	assert(m_is_initialized);

	if (std::string(sprite_path) == "") {
		return;
	}

	RenderQueueSpriteElement element;
	element.pos_x = pos_x;
	element.pos_y = pos_y;
	element.sprite_path = std::string(sprite_path);
	element.layer = layer;
	m_sprite_render_queue.push_back(element);
}

int RenderManager::GetSpriteWidth(const char * sprite_name) {
	assert(m_is_initialized);

	std::string sprite_path = std::string(sprite_name);

	if (m_sprites.find(sprite_path) != m_sprites.end()) {
		return m_sprites[sprite_path].width;
	}

	return -1;
}

int RenderManager::GetSpriteHeight(const char * sprite_name) {
	assert(m_is_initialized);

	std::string sprite_path = std::string(sprite_name);
	if (m_sprites.find(sprite_path) != m_sprites.end()) {
		return m_sprites[sprite_path].height;
	}

	return -1;
}

int RenderManager::GetTextWidth(const char * font_name, int font_size, const char * text) {
	assert(m_is_initialized);

	Font *font_to_be_rendered = nullptr;
	
	std::string font_path_str = std::string(font_name);
	for (auto font : m_fonts) {
		if (font.size == font_size && font.path == font_path_str) {
			font_to_be_rendered = &font;
			break;
		}
	}

	if (font_to_be_rendered != nullptr) {
		SDL_Surface* surface = TTF_RenderText_Blended(font_to_be_rendered->font, text, {0, 0, 0});
		SDL_Texture* texture = SDL_CreateTextureFromSurface(m_renderer, surface);

		SDL_Rect rect;
		int result = 0;
		SDL_QueryTexture(texture, NULL, NULL, &result, &rect.h);
		
		SDL_DestroyTexture(texture);
		SDL_FreeSurface(surface);
		
		return result;
	}
	else {
		return 0;
	}
}

int RenderManager::GetTextHeight(const char * font_name, int font_size, const char * text) {
	assert(m_is_initialized);

	Font *font_to_be_rendered = nullptr;

	std::string font_path_str = std::string(font_name);
	for (auto font : m_fonts) {
		if (font.size == font_size && font.path == font_path_str) {
			font_to_be_rendered = &font;
			break;
		}
	}

	if (font_to_be_rendered != nullptr) {
		SDL_Surface* surface = TTF_RenderText_Blended(font_to_be_rendered->font, text, { 0, 0, 0 });
		SDL_Texture* texture = SDL_CreateTextureFromSurface(m_renderer, surface);

		SDL_Rect rect;
		int result = 0;
		SDL_QueryTexture(texture, NULL, NULL, &rect.w, &result);

		SDL_DestroyTexture(texture);
		SDL_FreeSurface(surface);

		return result;
	}
	else {
		return 0;
	}
}
