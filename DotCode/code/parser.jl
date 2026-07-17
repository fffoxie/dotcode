using ParserCombinator

# =========================
# AST NODES
# =========================
abstract type Node end

struct NumberNode <: Node
    value::Int
end

struct PrintNode <: Node
    values::Vector{NumberNode}
    is_number_mode::Bool
end

struct IfNode <: Node
    left::NumberNode
    op::String
    right::NumberNode
    true_body::Node
    else_body::Union{Node, Nothing}
end

function value_to_char(val::Int)
    return Char(val + 64)
end

execute(n::NumberNode) = n.value

function execute(n::PrintNode)
    if n.is_number_mode
        print_val = join([string(execute(v)) for v in n.values], "")
        println(print_val)
    else
        print_val = join([value_to_char(execute(v)) for v in n.values], "")
        println(print_val)
    end
end

function execute(n::IfNode)
    left_val = execute(n.left)
    right_val = execute(n.right)
    
    condition = false
    if n.op == "<"
        condition = left_val < right_val
    elseif n.op == ">"
        condition = left_val > right_val
    end

    if condition
        execute(n.true_body)
    elseif n.else_body !== nothing
        execute(n.else_body)
    end
end

# =========================
# VALUE PARSERS
# =========================


dot_number = regex(r"\.+") |> (dots -> NumberNode(length(dots)))


dot_short_number = sequence(
    literal(".("),
    regex(r"\d+"),
    literal(")")
) |> (parts -> NumberNode(parse(Int, parts)))


any_value = dot_number | dot_short_number

# =========================
# STATEMENT PARSERS
# =========================

number_mode_print = sequence(
    literal(";"),
    literal("("),
    Repeat(any_value),
    literal(")")
) |> (parts -> PrintNode(parts, true))


alphabet_mode_print = sequence(
    literal(";"),
    any_value
) |> (parts -> PrintNode([parts], false))

print_statement = number_mode_print | alphabet_mode_print


comparison = sequence(
    any_value,
    regex(r"[<>]"),
    any_value
) |> (parts -> (left=parts, op=parts, right=parts))


statement = Delayed()

if_statement = sequence(
    literal("&"),
    comparison,
    statement,
    Optional(sequence(literal("#"), statement))
) |> (parts -> IfNode(
    parts.left, 
    parts.op, 
    parts.right, 
    parts, 
    parts === nothing ? nothing : parts
))


statement.matcher = if_statement | print_statement


program = many(statement)

# =========================
# TEST
# =========================
input = "& ... < .. ; .(3) # ; .."
result = parse_one(program, input) 

println(result)

input = "& ... < .. ; .(3) # ; .."
result = parse_one(program, input)

for node in result
    execute(node)
end

