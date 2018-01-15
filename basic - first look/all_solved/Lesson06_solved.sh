#!/bin/bash

# [PL]

# Lekcja 6 - zmienne globalne i zmienne lokalne.

# [ENG]

# Lesson 6 - global variables and local variables.

global_var="Zmienna"

function func_glob()
{
    local local_var="Zmienna lokalna"
    global_var="Zmienna zmieniona"
    global_var2="Jestem :)"
    echo "$local_var | $global_var"
}

main()
{
    echo "\$global_var: $global_var"
    func_glob
    echo "Czy zmienna jest dalej zmienną: \$global_var: $global_var, \$global_var2: $global_var2 i \$local_var: $local_var"
}

main
