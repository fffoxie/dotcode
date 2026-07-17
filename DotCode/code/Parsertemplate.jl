using ParserCombinator

abstract type Node end

struct NumberNode <: Node
    value
end

struct PrintNode <: Node
    value
end

struct IfNode <: Node
    condition
    body
    else_body
end


function symbol_parser(sym)
    token(literal(sym))
end


# edit: change this if DotCode numbers have a different format
number_parser = regex(r"\d+")


# edit: change this to match your variable naming rules
identifier_parser = regex(r"[a-zA-Z_][a-zA-Z0-9_]*")


# edit: define how normal dot numbers work
# example: ..... = 5
dot_number = regex(r"\.+") do dots
    NumberNode(length(dots))
end


# edit: change the shortcut syntax here
# example: .(26) = 26
dot_short_number = sequence(
    literal(".("),
    regex(r"\d+"),
    literal(")")
) do parts
    NumberNode(parse(Int, parts[2]))
end


# edit: change the print symbol here
# current: ; value
print_statement = sequence(
    literal(";"),
    dot_number
) do parts
    PrintNode(parts[2])
end


# edit: add more operators here
# example: < > = == !=
comparison = sequence(
    dot_number,
    regex(r"[<>]"),
    dot_number
) do parts
    (
        left = parts[1],
        operator = parts[2],
        right = parts[3]
    )
end


# edit: change if syntax here
# current:
# & condition
#     code
if_statement = sequence(
    literal("&"),
    comparison,
    print_statement
) do parts
    IfNode(
        parts[2],
        parts[3],
        nothing
    )
end


# edit: add new DotCode commands here
# example:
# variable_statement |
# loop_statement |
# function_statement
statement =
    if_statement |
    print_statement


# edit: change how many statements are allowed
program = many(statement)


input = """
; .....
"""

result = parse(program, input)

println(result)