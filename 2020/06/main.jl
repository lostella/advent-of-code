function main(input_path)
    lines = collect(map(line -> line == "" ? "%" : line, eachline(input_path)))
    groups = split(join(lines), "%")
    println(sum(length(unique(g)) for g in groups))
    groups = split(join(lines, "\n"), "\n%\n")
    println(sum(length(foldl(intersect, split(g, "\n"))) for g in groups))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(joinpath(dirname(@__FILE__), "input"))
end
