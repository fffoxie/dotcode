# =========================
# TOKEN STRUCTURE
# =========================

struct Token
    type::String
    value::String
end


# =========================
# TOKENIZER FUNCTION
# =========================

function tokenize(input::String)
    tokens = Vector{Token}()
    i = 1

    while i <= lastindex(input)
        c = input[i]

        # -------------------------
        # DOTS (numbers like ..... = 5)
        # -------------------------
        if c == '.'
            dot_count = 0

            while i <= lastindex(input) && input[i] == '.'
                dot_count += 1
                i += 1
            end

            push!(tokens, Token("Dot", string(dot_count)))

        # -------------------------
        # SYMBOLS
        # -------------------------
        elseif c == ';'
            push!(tokens, Token("Semicolon", ";"))
            i += 1

        elseif c == '&'
            push!(tokens, Token("Ampersand", "&"))
            i += 1

        elseif c == '#'
            push!(tokens, Token("Hash", "#"))
            i += 1

        elseif c == '<'
            push!(tokens, Token("LessThan", "<"))
            i += 1

        elseif c == '>'
            push!(tokens, Token("GreaterThan", ">"))
            i += 1

        elseif c == '('
            push!(tokens, Token("LeftParen", "("))
            i += 1

        elseif c == ')'
            push!(tokens, Token("RightParen", ")"))
            i += 1

        # -------------------------
        # WHITESPACE
        # -------------------------
        elseif isspace(c)
            i += 1

        # -------------------------
        # ERROR HANDLING
        # -------------------------
        else
            error("Unexpected character: '$c' at position $i")
        end
    end

    return tokens
end


# =========================
# TESTS
# =========================

function run_tests()
    tests = [
        "; .....",
        "; .(26)",
        "& ... < .. ; ...",
        "& ... < .. ; .(3) # ;.."
    ]

    for (idx, test) in enumerate(tests)
        println("\nTest $idx: $test")
        println(tokenize(test))
    end
end


run_tests()