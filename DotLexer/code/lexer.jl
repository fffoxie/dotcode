# This file is part of the DotCode project. It is used in the main program.

TokenType = ("Number", "Let","Identifier", "Equals", "Plus", "Minus", "Multiply", "Divide", "LeftParen", "RightParen")
    
struct Token
    kind::String
    value::String
end

function tokenize(input::String)
    tokens = Token[]
    i = 1
    while i <= lastindex(input)
        c = input[i]
        
        if isdigit(c)
            num = ""
            while i <= lastindex(input) && isdigit(input[i])
                num *= input[i]
                i += 1
            end
            push!(tokens, Token("Number", num))
            
        elseif isletter(c)
            id = ""
            while i <= lastindex(input) && isletter(input[i])
                id *= input[i]
                i += 1
            end
            
            if id == "let"
                push!(tokens, Token("Let", id))
            else 
                push!(tokens, Token("Identifier", id))
            end
            
        elseif c == '='
            push!(tokens, Token("Equals", "="))
            i += 1
        elseif c == '+'
            push!(tokens, Token("Plus", "+"))
            i += 1
        elseif c == '-'
            push!(tokens, Token("Minus", "-"))
            i += 1
        elseif c == '*'
            push!(tokens, Token("Multiply", "*"))
            i += 1
        elseif c == '/'
            push!(tokens, Token("Divide", "/"))
            i += 1
        elseif c == '('
            push!(tokens, Token("LeftParen", "("))
            i += 1
        elseif c == ')'
            push!(tokens, Token("RightParen", ")"))
            i += 1
        elseif c in [' ', '\t', '\n']
            i += 1
        else
            error("Unexpected character: $c")
        end
    end
    return tokens
end

test_string = "let x = 45 * (2 + 3)"
println("testing string: ", test_string)

results = tokenize(test_string)

for t in results
    println("token type: ", t.kind, " | value: ", t.value)
end