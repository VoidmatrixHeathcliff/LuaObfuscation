Obfuscator = require("Obfuscator")

local FixedList = {
    -- lua primary environment
    -- basic
    "_G", "_VERSION", "assert", "collectgarbage", "dofile", "error", "getmetatable",
    "ipairs", "load", "loadfile", "next", "pairs", "pcall", "print", "rawequal", "rawget",
    "rawlen", "rawset", "require", "select", "setmetatable", "tonumber", "tostring", "type",
    "warn", "xpcall", "self", "const", "close",
    -- coroutine
    "coroutine", "close", "create", "isyieldable", "resume", "running", "status", "wrap", "yield",
    -- debug
    "debug", "gethook", "getinfo", "getlocal", "getmetatable", "getregistry", "getupvalue",
    "getuservalue", "sethook", "setlocal", "setmetatable", "setupvalue", "setuservalue", "traceback",
    "upvalueid", "upvaluejoin",
    -- io
    "io", "close",
    "flush", "input", "lines", "open", "output", "popen", "read", "stderr", "stdin", "stdout",
    "tmpfile", "type", "write", "close", "flush", "lines", "read", "seek", "setvbuf", "write",
    -- math
    "math", "abs", "acos", "asin", "atan", "ceil", "cos", "deg", "exp", "floor", "fmod", "huge",
    "log", "max", "maxinteger", "min", "mininteger", "modf", "pi", "rad", "random", "randomseed",
    "sin", "sqrt", "tan", "tointeger", "type", "ult",
    -- os
    "os", "clock", "date", "difftime", "execute", "exit", "getenv", "remove", "rename", "setlocale",
    "time", "tmpname",
    -- package
    "package", "config", "cpath", "loaded", "loadlib", "path", "preload", "searchers", "searchpath",
    -- string
    "string", "byte", "char", "dump", "find", "format", "gmatch", "gsub", "len", "lower", "match",
    "pack", "packsize", "rep", "reverse", "sub", "unpack", "upper",
    -- table
    "table", "concat", "insert", "move", "pack", "remove", "sort", "unpack",
    -- utf8
    "utf8", "char", "charpattern", "codepoint", "codes", "len", "offset",
    -- metamethods
    "__add", "__band", "__bnot", "__bor", "__bxor", "__call", "__close", "__concat", "__div", "__eq",
    "__gc", "__idiv", "__index", "__le", "__len", "__lt", "__metatable", "__mod", "__mode", "__mul",
    "__name", "__newindex", "__pairs", "__pow", "__shl", "__shr", "__sub", "__tostring", "__unm",

    -- EtherEngine extended environment
    -- basic
    "_ARGV", "_ENVP", "_VERSION_ENGINE", "x", "y", "w", "h", "r", "g", "b", "a", "h", "l", "s",
    -- module Algorithm
    "Clamp", "CheckPointInRect", "CheckPointInCircle", "CheckRectsOverlap", "CheckCirclesOverlap",
    "GetPointsDistance", "GetLinesDistance", "GetPointLineDistanc", "RGBAToHSLA", "HSLAToRGBA",
    "EncodeBase64", "DecodeBase64",
    -- module Graphic
    "SetRenderMode", "ImageFile", "ImageBuffer", "CreateTexture", "RenderTexture", "RenderTextureEx",
    "SetDrawColor",	"GetDrawColor", "DrawPoint", "DrawLine", "DrawRectangle", "DrawRoundRectangle",
    "DrawCircle", "DrawEllipse", "DrawPie", "DrawTriangle", "DrawPolygon", "DrawBezier", "FontFile",
    "FontBuffer", "GetTextSize", "TextImageFast", "TextImageQuality", "TextImageShaded","FLIP_HORIZONTAL",
    "FLIP_VERTICAL", "FLIP_NONE", "FONT_BOLD", "FONT_ITALIC", "FONT_UNDERLINE", "FONT_STRIKETHROUGH",
    "FONT_NORMAL", "RENDER_NEAREST", "RENDER_LINEAR", "SetColorKey", "Size","SetAlpha", "GetStyle",
    "SetStyle",	"GetOutlineWidth", "SetOutlineWidth", "GetKerning", "SetKerning", "Height",
    -- module Input
    "UpdateEvent", "StartTextInput", "StartTextInput", "GetEventType", "GetMouseButtonID", "GetKeyCode",
    "GetCursorPosition", "GetWheelScroll", "GetInputText", "GetDropFile", "EVENT_QUIT", "EVENT_MOUSEMOTION",
    "EVENT_MOUSEWHEEL", "EVENT_TEXTINPUT", "EVENT_KEYDOWN",	"EVENT_KEYUP", "EVENT_DROPFILE", "EVENT_DROPBEGIN",
    "EVENT_DROPCOMPLETE", "EVENT_WINDOW", "EVENT_MOUSEBTNDOWN", "EVENT_MOUSEBTNUP", "WINDOWEVENT_SHOWN",
    "WINDOWEVENT_HIDDEN", "WINDOWEVENT_EXPOSED", "WINDOWEVENT_MOVED", "WINDOWEVENT_RESIZED", "WINDOWEVENT_MINIMIZED",
    "WINDOWEVENT_MAXIMIZED", "WINDOWEVENT_ENTER", "WINDOWEVENT_LEAVE", "WINDOWEVENT_FOCUSGOT ", "WINDOWEVENT_FOCUSLOST",
    "WINDOWEVENT_CLOSE", "MOUSEBTN_LEFT", "MOUSEBTN_RIGHT", "MOUSEBTN_MIDDLE", "KEY_0", "KEY_1", "KEY_2", "KEY_3",
    "KEY_4", "KEY_5", "KEY_6", "KEY_7",	"KEY_8", "KEY_9", "KEYPAD_0", "KEYPAD_00", "KEYPAD_000", "KEYPAD_1", "KEYPAD_2",
    "KEYPAD_3", "KEYPAD_4", "KEYPAD_5", "KEYPAD_6", "KEYPAD_7", "KEYPAD_8", "KEYPAD_9", "KEY_F1", "KEY_F2", "KEY_F3",
    "KEY_F4", "KEY_F5", "KEY_F6", "KEY_F7", "KEY_F8", "KEY_F9",	"KEY_F11", "KEY_F12", "KEY_F13", "KEY_F14", "KEY_F15",
    "KEY_F16", "KEY_F17", "KEY_F18", "KEY_F19", "KEY_F20", "KEY_F21", "KEY_F22", "KEY_F23", "KEY_F24", "KEY_A",
    "KEY_B", "KEY_C", "KEY_D", "KEY_E", "KEY_F", "KEY_G", "KEY_H", "KEY_I", "KEY_J", "KEY_K", "KEY_L", "KEY_M",
    "KEY_N", "KEY_O", "KEY_P", "KEY_Q", "KEY_R", "KEY_S", "KEY_T", "KEY_U", "KEY_V", "KEY_W", "KEY_X", "KEY_Y",
    "KEY_Z", "KEYPAD_A", "KEYPAD_B", "KEYPAD_C", "KEYPAD_D", "KEYPAD_E", "KEYPAD_F", "KEY_ESC", "KEY_ENTER",
    "KEYPAD_ENTER", "KEY_BACKSPACE", "KEYPAD_BACKSPACE", "KEY_RIGHT", "KEY_LEFT", "KEY_DOWN", "KEY_UP", "KEY_INSERT",
    "KEY_DELETE", "KEY_HOME", "KEY_END", "KEY_PAGEUP", "KEY_PAGEDOWN", "KEY_LCTRL", "KEY_LGUI", "KEY_LALT", "KEY_LSHIFT",
    "KEY_RCTRL", "KEY_RGUI", "KEY_RALT", "KEY_RSHIFT", "KEY_SPACE",	"KEY_TAB", "KEYPAD_TAB", "KEY_CAPSLOCK", "KEY_NUMLOCK",
    "KEY_PRINTSCREEN", "KEY_SCROLLLOCK", "KEY_PAUSE", "KEY_AUDIOMUTE", "KEY_AUDIOPREV", "KEY_AUDIONEXT", "KEY_AUDIOPLAY",
    "KEY_AUDIOSTOP", "KEY_VOLUMEUP", "KEY_VOLUMEDOWN", "KEY_BRIGHTNESSUP", "KEY_BRIGHTNESSDOWN", "KEY_BACKQUOTE",
    "KEY_EXCLAIM", "KEYPAD_EXCLAIM", "KEY_AT", "KEYPAD_AT", "KEY_HASH", "KEYPAD_HASH", "KEY_DOLLAR", "KEY_CARET",
    "KEYPAD_CARET", "KEY_AMPERSAND", "KEYPAD_AMPERSAND", "KEYPAD_DBLAMPERSAND", "KEY_ASTERISK", "KEYPAD_ASTERISK",
    "KEY_LPAREN", "KEYPAD_LPAREN", "KEY_RPAREN", "KEYPAD_RPAREN", "KEY_MINUS", "KEYPAD_MINUS", "KEY_UNDERSCORE",
    "KEY_PLUS", "KEYPAD_PLUS", "KEY_EQUALS", "KEYPAD_EQUALS", "KEY_LBRACKET", "KEY_RBRACKET", "KEYPAD_LBRACE",
    "KEYPAD_RBRACE", "KEY_COLON", "KEY_SEMICOLON", "KEY_BACKSLASH", "KEY_QUOTE", "KEY_DBLQUOTE", "KEY_LESS", "KEY_GREATER",
    "KEY_COMMA", "KEY_PERIOD", "KEY_QUESTION", "KEY_SLASH",	"KEY_VERTICALBAR", "KEYPAD_DBLVERTICALBAR", "KEY_WWW", "KEY_MAIL",
    -- module JSON
    "Load", "Dump", "SetStrictArrayMode", "GetStrictArrayMode",
    -- module Media
    "MusicFile", "MusicBuffer", "PlayMusic", "StopMusic", "SetMusicPosition", "GetMusicVolume", "PauseMusic", "ResumeMusic",
    "RewindMusic", "CheckMusicPlaying", "CheckMusicPaused", "GetMusicFadingType", "SoundFile", "SoundBuffer", "MUSIC_WAV",
    "MUSIC_MP3", "MUSIC_OGG", "MUSIC_CMD", "MUSIC_MOD", "MUSIC_MID", "MUSIC_UNKNOWN", "Type", "Play", "SetVolume", "GetVolume",
    -- module String
    "GBKToUTF8", "UTF8ToGBK", "UTF8Len", "UTF8Sub", "UTF8Find", "UTF8RFind", "UTF8Insert",
    -- module Time
    "Sleep", "GetInitTime", "GetPerformanceCounter", "GetPerformanceFrequency",
    -- module Window
    "GetWindowHandle", "GetRendererHandle", "SetCursorShown", "GetCursorShown", "SetCursorStyle", "GetCursorStyle", "MessageBox",
    "ConfirmBox", "Create", "Close", "SetTitle", "GetTitle", "SetStyle", "SetOpacity", "SetSize", "GetSize", "GetDrawableSize",
    "SetMaxSize", "GetMaxSize",	"SetMinSize", "GetMinSize", "SetPosition", "GetPosition", "SetIcon", "Clear", "Update", "DEFAULT_POS",
    "MSGBOX_ERR", "MSGBOX_WARN", "MSGBOX_INFO", "FULLSCREEN", "BORDERLESS", "RESIZABLE", "MAXIMIZED", "MINIMIZED", "WINDOWED",
    "FIXED", "CURSOR_ARROW", "CURSOR_IBEAM", "CURSOR_WAIT", "CURSOR_CROSSHAIR", "CURSOR_WAITARROW", "CURSOR_SIZENWSE", "CURSOR_SIZENESW",
    "CURSOR_SIZEWE", "CURSOR_SIZENS", "CURSOR_SIZEALL", "CURSOR_NO", "CURSOR_HAND",
    -- module Compress
    "CompressData", "DecompressData",
    -- module Debug
    "GetCoreError",

    -- custom environment
    -- DreamGUI
    "UpdateEvent", "UpdateFrame", "Remove", "Load", "Dump", "Clear",
    "DialogBox", "Label", "Button", "Switch",
}

Obfuscator.SetFixedList(FixedList)

Obfuscator.Obfuscate({"DreamGUI.lua", "DFCore.lua"}, true)

os.execute("pause")