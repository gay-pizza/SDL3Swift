#pragma once

#include <SDL3/SDL.h>

/* SDL_stdinc.h */
#undef SDL_MAX_UINT64
#define SDL_MAX_UINT64 0xFFFFFFFFFFFFFFFFul  /* 18446744073709551615 */
#undef SDL_MIN_UINT64
#define SDL_MIN_UINT64 0x0000000000000000ul  /* 0 */

/* SDL_video.h */
#undef SDL_WINDOW_FULLSCREEN
#define SDL_WINDOW_FULLSCREEN 0x0000000000000001ul  /**< window is in fullscreen mode */
#undef SDL_WINDOW_OPENGL
#define SDL_WINDOW_OPENGL 0x0000000000000002ul  /**< window usable with OpenGL context */
#undef SDL_WINDOW_OCCLUDED
#define SDL_WINDOW_OCCLUDED 0x0000000000000004ul  /**< window is occluded */
#undef SDL_WINDOW_HIDDEN
#define SDL_WINDOW_HIDDEN 0x0000000000000008ul  /**< window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible */
#undef SDL_WINDOW_BORDERLESS
#define SDL_WINDOW_BORDERLESS 0x0000000000000010ul  /**< no window decoration */
#undef SDL_WINDOW_RESIZABLE
#define SDL_WINDOW_RESIZABLE 0x0000000000000020ul  /**< window can be resized */
#undef SDL_WINDOW_MINIMIZED
#define SDL_WINDOW_MINIMIZED 0x0000000000000040ul  /**< window is minimized */
#undef SDL_WINDOW_MAXIMIZED
#define SDL_WINDOW_MAXIMIZED 0x0000000000000080ul  /**< window is maximized */
#undef SDL_WINDOW_MOUSE_GRABBED
#define SDL_WINDOW_MOUSE_GRABBED 0x0000000000000100ul  /**< window has grabbed mouse input */
#undef SDL_WINDOW_INPUT_FOCUS
#define SDL_WINDOW_INPUT_FOCUS 0x0000000000000200ul  /**< window has input focus */
#undef SDL_WINDOW_MOUSE_FOCUS
#define SDL_WINDOW_MOUSE_FOCUS 0x0000000000000400ul  /**< window has mouse focus */
#undef SDL_WINDOW_EXTERNAL
#define SDL_WINDOW_EXTERNAL 0x0000000000000800ul  /**< window not created by SDL */
#undef SDL_WINDOW_MODAL
#define SDL_WINDOW_MODAL 0x0000000000001000ul  /**< window is modal */
#undef SDL_WINDOW_HIGH_PIXEL_DENSITY
#define SDL_WINDOW_HIGH_PIXEL_DENSITY 0x0000000000002000ul  /**< window uses high pixel density back buffer if possible */
#undef SDL_WINDOW_MOUSE_CAPTURE
#define SDL_WINDOW_MOUSE_CAPTURE 0x0000000000004000ul  /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
#undef SDL_WINDOW_MOUSE_RELATIVE_MODE
#define SDL_WINDOW_MOUSE_RELATIVE_MODE 0x0000000000008000ul  /**< window has relative mode enabled */
#undef SDL_WINDOW_ALWAYS_ON_TOP
#define SDL_WINDOW_ALWAYS_ON_TOP 0x0000000000010000ul  /**< window should always be above others */
#undef SDL_WINDOW_UTILITY
#define SDL_WINDOW_UTILITY 0x0000000000020000ul  /**< window should be treated as a utility window, not showing in the task bar and window list */
#undef SDL_WINDOW_TOOLTIP
#define SDL_WINDOW_TOOLTIP 0x0000000000040000ul  /**< window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window */
#undef SDL_WINDOW_POPUP_MENU
#define SDL_WINDOW_POPUP_MENU 0x0000000000080000ul  /**< window should be treated as a popup menu, requires a parent window */
#undef SDL_WINDOW_KEYBOARD_GRABBED
#define SDL_WINDOW_KEYBOARD_GRABBED 0x0000000000100000ul  /**< window has grabbed keyboard input */
#undef SDL_WINDOW_VULKAN
#define SDL_WINDOW_VULKAN 0x0000000010000000ul  /**< window usable for Vulkan surface */
#undef SDL_WINDOW_METAL
#define SDL_WINDOW_METAL 0x0000000020000000ul  /**< window usable for Metal view */
#undef SDL_WINDOW_TRANSPARENT
#define SDL_WINDOW_TRANSPARENT 0x0000000040000000ul  /**< window with transparent buffer */
#undef SDL_WINDOW_NOT_FOCUSABLE
#define SDL_WINDOW_NOT_FOCUSABLE 0x0000000080000000ul  /**< window should not be focusable */
