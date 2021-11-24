local __module = {} 

local PathFile = nil

local WordList = 
{
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "_",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
}

local KeywordList = {}

for _, _word in ipairs({
    "and", "break", "do", "else", "elseif", "end", 
    "false", "for", "function", "if", "in", "local", 
    "nil", "not", "or", "repeat", "return", "then", 
    "true", "until", "while", "goto"
}) do KeywordList[_word] = string.upper(_word) end

local TokenType = {}

for _, _word in ipairs({
    "keyword", "identifier", "literal", "operator"
}) do TokenType[_word] = string.upper(_word) end

local ErrorMsg = 
{
    malformed_number = "malformed number",
    unexpected_symbol = "unexpected symbol"
}

local Error = function(msg, line, file)
    error(string.format("[%s:%d:%s]", file, line, msg), 2)
end

local Tokenize = function(_code, _tk_list)

    local _Has = function(_str, _idx)
        return _idx > 0 and _idx <= #_str
    end

    local _At = function(_str, _idx)
        return string.sub(_str, _idx, _idx)
    end

    local _idx, _line_num = 1, 1

    while _Has(_code, _idx) do

        local _char = _At(_code, _idx)

        if string.match(_char, "[%s]") then
            if _char == "\n" then 
                _line_num = _line_num + 1 
            end
            _idx = _idx + 1
        elseif string.match(_char, "[%a_]")then
            local _idx_start = _idx
            while string.match(_At(_code, _idx), "[%w_]") do 
                _idx = _idx + 1
            end
            local _tk = 
            {
                type = TokenType.identifier,
                value = string.sub(_code, _idx_start, _idx - 1),
                line = _line_num
            }
            if KeywordList[_tk.value] then
                _tk.type = TokenType.keyword
            end
            table.insert(_tk_list, _tk)
        elseif string.match(_char, "[%d]") then
            local _idx_start = _idx
            if _char == "0" and string.lower(_At(_code, _idx + 1)) == "x" then
                _idx = _idx + 2
                while string.match(_At(_code, _idx), "[%w]") do
                    _idx = _idx + 1
                end
                if _At(_code, _idx) == "." and _At(_code, _idx + 1) ~= "." then
                    _idx = _idx + 1
                    while string.match(_At(_code, _idx), "[%w]") do
                        _idx = _idx + 1
                    end
                end
                table.insert(_tk_list, {
                    type = TokenType.literal,
                    value = string.sub(_code, _idx_start, _idx - 1),
                    line = _line_num
                })
            else
                while string.match(_At(_code, _idx), "[%d]") do 
                    _idx = _idx + 1
                end
                local _tmp_char = _At(_code, _idx)
                if _tmp_char == "." and _At(_code, _idx + 1) ~= "." then
                    _idx = _idx + 1
                    while string.match(_At(_code, _idx), "[%d]") do 
                        _idx = _idx + 1
                    end
                    if string.lower(_tmp_char) == "e" then
                        _idx = _idx + 1
                        if string.match(_At(_code, _idx), "[%+%-]") then
                            _idx = _idx + 1
                        end
                        while string.match(_At(_code, _idx), "[%d]") do 
                            _idx = _idx + 1
                        end
                    end
                elseif string.lower(_tmp_char) == "e" then
                    _idx = _idx + 1
                    if string.match(_At(_code, _idx), "[%+%-]") then
                        _idx = _idx + 1
                    end
                    while string.match(_At(_code, _idx), "[%d]") do 
                        _idx = _idx + 1
                    end
                end
                table.insert(_tk_list, {
                    type = TokenType.literal,
                    value = string.sub(_code, _idx_start, _idx - 1),
                    line = _line_num
                })
            end
        elseif string.match(_char, "[,]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = ",",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%.]") then
            local _idx_start = _idx
            if _At(_code, _idx + 1) == "." then
                _idx = _idx + 1
            end
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = string.sub(_code, _idx_start, _idx),
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[:]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = ":",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[=]") then
            local _idx_start = _idx
            if _At(_code, _idx + 1) == "=" then
                _idx = _idx + 1
            end
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = string.sub(_code, _idx_start, _idx),
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[~]") then
            local _idx_start = _idx
            if _At(_code, _idx + 1) == "=" then
                _idx = _idx + 1
            end
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = string.sub(_code, _idx_start, _idx),
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[<]") then
            local _idx_start = _idx
            if string.match(_At(_code, _idx + 1), "[=<]") then
                _idx = _idx + 1
            end
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = string.sub(_code, _idx_start, _idx),
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[>]") then
            local _idx_start = _idx
            if string.match(_At(_code, _idx + 1), "[=>]") then
                _idx = _idx + 1
            end
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = string.sub(_code, _idx_start, _idx),
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[&]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "&",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[|]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "|",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%[]") then
            if _At(_code, _idx + 1) == "=" then
                local _idx_start, _num_equals = _idx, 0
                _idx = _idx + 1
                while _Has(_code, _idx) and _At(_code, _idx) == "=" do
                    _idx = _idx + 1
                    _num_equals = _num_equals + 1
                end
                if _At(_code, _idx) == "[" then
                    local _str_end = string.format("]%s]", string.rep("=", _num_equals))
                    while _Has(_code, _idx) and 
                        string.sub(_code, _idx, _idx + #_str_end - 1) ~= _str_end do
                        if _At(_code, _idx) == "\n" then _line_num = _line_num + 1 end
                        _idx = _idx + 1
                    end
                    table.insert(_tk_list, {
                        type = TokenType.literal,
                        value = string.gsub(string.sub(_code, _idx_start, _idx + #_str_end - 1), "\n", "\\n"),
                        line = _line_num
                    })
                    _idx = _idx + #_str_end
                else
                    table.insert(_tk_list, {
                        type = TokenType.operator,
                        value = string.sub(_code, _idx_start, _idx - 1),
                        line = _line_num
                    })
                end
            elseif _At(_code, _idx + 1) == "[" then
                local _idx_start = _idx
                while _Has(_code, _idx) and 
                    string.sub(_code, _idx, _idx + 1) ~= "]]" do
                    if _At(_code, _idx) == "\n" then _line_num = _line_num + 1 end
                    _idx = _idx + 1
                end
                table.insert(_tk_list, {
                    type = TokenType.literal,
                    value = string.gsub(string.sub(_code, _idx_start, _idx + 1), "\n", "\\n"),
                    line = _line_num
                })
                _idx = _idx + 2
            else
                table.insert(_tk_list, {
                    type = TokenType.operator,
                    value = "[",
                    line = _line_num
                })
                _idx = _idx + 1
            end
        elseif string.match(_char, "[%]]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "]",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%(]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "(",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%)]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = ")",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[{]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "{",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%}]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "}",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%+]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "+",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%-]") then
            if _At(_code, _idx + 1) == "-" then
                if _At(_code, _idx + 2) == "[" then
                    _idx = _idx + 3
                    if _At(_code, _idx) == "=" then
                        local _num_equals = 0
                        while _Has(_code, _idx) and _At(_code, _idx) == "=" do
                            _idx = _idx + 1
                            _num_equals = _num_equals + 1
                        end
                        if _At(_code, _idx) == "[" then
                            local _str_end = string.format("]%s]", string.rep("=", _num_equals))
                            while _Has(_code, _idx) and 
                                string.sub(_code, _idx, _idx + #_str_end - 1) ~= _str_end do
                                if _At(_code, _idx) == "\n" then _line_num = _line_num + 1 end
                                _idx = _idx + 1
                            end
                            _idx = _idx + #_str_end
                        else
                            while _Has(_code, _idx) and _At(_code, _idx) ~= "\n" do
                                _idx = _idx + 1
                            end
                            _line_num = _line_num + 1
                            _idx = _idx + 1
                        end
                    elseif _At(_code, _idx) == "[" then
                        local _idx_start = _idx
                        while _Has(_code, _idx) and 
                            string.sub(_code, _idx, _idx + 1) ~= "]]" do
                            if _At(_code, _idx) == "\n" then _line_num = _line_num + 1 end
                            _idx = _idx + 1
                        end
                        _idx = _idx + 2
                    else
                        while _Has(_code, _idx) and _At(_code, _idx) ~= "\n" do
                            _idx = _idx + 1
                        end
                        _line_num = _line_num + 1
                        _idx = _idx + 1
                    end
                else
                    while _Has(_code, _idx) and _At(_code, _idx) ~= "\n" do
                        _idx = _idx + 1
                    end
                    _line_num = _line_num + 1
                    _idx = _idx + 1
                end
            else
                table.insert(_tk_list, {
                    type = TokenType.operator,
                    value = "-",
                    line = _line_num
                })
                _idx = _idx + 1
            end
        elseif string.match(_char, "[%*]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "*",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[/]") then
            local _idx_start = _idx
            if _At(_code, _idx + 1) == "/" then
                _idx = _idx + 1
            end
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = string.sub(_code, _idx_start, _idx),
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%^]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "^",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[%%]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "%",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[#]") then
            table.insert(_tk_list, {
                type = TokenType.operator,
                value = "#",
                line = _line_num
            })
            _idx = _idx + 1
        elseif string.match(_char, "[\'\"]") then
            local _idx_start = _idx
            _idx = _idx + 1
            if _char == "\"" then
                while _Has(_code, _idx) and _At(_code, _idx) ~= "\"" do
                    _idx = _idx + 1
                end
            else 
                while _Has(_code, _idx) and _At(_code, _idx) ~= "\'" do
                    _idx = _idx + 1
                end
            end
            table.insert(_tk_list, {
                type = TokenType.literal,
                value = string.sub(_code, _idx_start, _idx),
                line = _line_num
            })
            _idx = _idx + 1
        else
            Error(ErrorMsg.unexpected_symbol, _line_num, PathFile)
        end

    end

end

local FixedList = {}

__module.SetFixedList = function(_list)

    if type(_path) ~= "table" then
        error("table expected")
    end

    FixedList = {}
    for _, _word in ipairs(_list) do
        FixedList[_word] = true
    end

end

__module.Compress = function(_path)

    local _Handle = function(_file)

        PathFile = _file

        local _in_file = io.open(_file, "r")
        if not _in_file then
            error(string.format("failed to open file: %s", _file))
        end

        local _token_list = {}
        Tokenize(_in_file:read("*a"), _token_list)

        local _result = ""
        for _idx, _token in ipairs(_token_list) do
            _result = _result.._token.value
            if _token.type ~= "OPERATOR" then
                local _next_token = _token_list[_idx + 1]
                if _next_token and _next_token.type ~= "OPERATOR" then
                    _result = _result.." "
                end
            end
        end

        _in_file:close()

        local _out_file = io.open(_file..".min.lua", "w")
        _out_file:write(_result)
        _out_file:close()
    end

    if type(_path) == "string" then
        _Handle(_path)
    elseif type(_path) == "table" then
        for _, _file in ipairs(_path) do
            _Handle(_file)
        end
    else
        error("args expected string or table")
    end

end

__module.Obfuscate = function(_path, _debug)

    local _token_list = {}
    local _map_src_to_dst = {}
    local _map_dst_to_src = {}

    local _GenNewDst = function()
        local _dst = WordList[math.random(11, #WordList)]
        local _len = math.random(1, 32)
        for i = 2, _len do
            _dst = _dst..WordList[math.random(1, #WordList)]
        end
        return _dst
    end

    local _Handle = function(_file)

        PathFile = _file

        local _in_file = io.open(_file, "r")
        if not _in_file then
            error(string.format("failed to open file: %s", _file))
        end

        local _token_list = {}
        Tokenize(_in_file:read("*a"), _token_list)

        local _result = ""
        for _idx, _token in ipairs(_token_list) do
            if _token.type == "IDENTIFIER" and not FixedList[_token.value] then
                local _dst = _map_src_to_dst[_token.value]
                if not _dst then
                    _dst = _GenNewDst()
                    while _map_dst_to_src[_dst] do _dst = _GenNewDst() end
                    _map_src_to_dst[_token.value] = _dst
                    _map_dst_to_src[_dst] = _token.value
                end
                _result = _result.._dst
            else
                _result = _result.._token.value
            end
            
            if _token.type ~= "OPERATOR" then
                local _next_token = _token_list[_idx + 1]
                if _next_token and _next_token.type ~= "OPERATOR" then
                    _result = _result.." "
                end
            end
        end

        _in_file:close()

        local _out_file = io.open(_file..".mix.lua", "w")
        _out_file:write(_result)
        _out_file:close()

        if _debug then
            local _debug_list = {}
            for _, _token in ipairs(_token_list) do
                local _info = 
                {
                    src = _token.value,
                    type = _token.type,
                    line = _token.line
                }
                if _token.type == "IDENTIFIER" then
                    _info.dst = _map_src_to_dst[_token.value]
                end
                table.insert(_debug_list, _info)
            end
            local _ModuleJSON = require("@JSON")
            _ModuleJSON.SetStrictArrayMode(true)
            local _debug_file = io.open(_file..".map.json", "w")
            _debug_file:write(_ModuleJSON.Dump(_debug_list, true))
            _debug_file:close()
        end

    end

    if type(_path) == "string" then
        _Handle(_path)
    elseif type(_path) == "table" then
        for _, _file in ipairs(_path) do
            _Handle(_file)
        end
    else
        error("args expected string or table")
    end

end

return __module