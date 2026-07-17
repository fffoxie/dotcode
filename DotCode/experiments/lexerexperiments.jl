
# =========================
# TOKEN DEFINITION
# =========================

struct Token
    type::String
    value::String
end


# =========================
# LEXER FUNCTION
# =========================

function tokenize(input::String)
    tokens = Vector{Token}()
    i = 1

    while i <= lastindex(input)
        c = input[i]

        # =========================
        # DOT / NUMBER SYSTEM
        # =========================
        if c == '.'
            i += 1

            # skip whitespace after dot
            while i <= lastindex(input) && isspace(input[i])
                i += 1
            end

            # CASE 1: .(26) style number
            if i <= lastindex(input) && input[i] == '('
                i += 1
                num = ""

                while i <= lastindex(input) && input[i] != ')'
                    num *= input[i]
                    i += 1
                end

                i += 1 # skip ')'

                push!(tokens, Token("Number", num))

            # CASE 2: ..... style dots
            else
                dot_count = 1

                while i <= lastindex(input) && input[i] == '.'
                    dot_count += 1
                    i += 1
                end

                push!(tokens, Token("Dot", string(dot_count)))
            end

        # =========================
        # SYMBOL TOKENS
        # =========================
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

        # =========================
        # WHITESPACE
        # =========================
        elseif isspace(c)
            i += 1

        # =========================
        # ERROR HANDLING
        # =========================
        else
            error("Unexpected character '$c' at position $i")
        end
    end

    return tokens
end


# =========================
# DEBUG / TEST RUNNER
# =========================

function run_tests()
    tests = [
        "; .....",
        "; .(26)",
        "& ... < .. ; ...",
        "& ... < .. ; .(3) # ;.."
    ]

    for (idx, test) in enumerate(tests)
        println("\n======================")
        println("Test $idx: $test")
        println("======================")

        toks = tokenize(test)

        for t in toks
            println("$(t.type) -> $(t.value)")
        end
    end
end


# =========================
# EXECUTION
# =========================

run_tests()