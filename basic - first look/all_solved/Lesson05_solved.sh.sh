#!/bin/bash

# [PL]
# Lekcja 5. 

# Poznaliśmy już jedną pętle for - poznajmy następne w prostych małych ćwiczeniach.

# for
# for, in, do, done są słowami kluczowymi

# [ENG]
# Lesson 5.

# We have already learned one for loops - learn more in simple small exercises.

# for
# for, in, do, done are keywords

# while

# break, continue - interrupting, skipping in a loop.

# select

function example_for_01()
{
    # Lista iteracyjnych elementów zapisana w jednej zmienej, odstep miedzy nakami w postaci spacti pozwala na potraktowanie ich jako osobny element. Wykonac iteracje.
    # List of iterative elements written in one variable, the space between spars in the form of spacti allows you to treat them as a separate element. Perform iterations.
    words="A B C D E F G H I J K L M N O P R S T U Q W Y X Z"
    echo "Nasz alfabet"
    for word in $words
    do
        echo -n "${word}."
    done
    echo ""
}

function example_for_02()
{
    # Lista iteracyjnych elementów tutaj zastosowanie cudzysłowia powoduje potrzaktowanie wszystkich elemantów jako całość.
    # List of iterative elements here, the use of inverted commas results in all elemantas as a whole.
    words="A B C D E F G H I J K L M N O P R S T U Q W Y X Z"
    echo "Nasz alfabet"
    for word in "$words"
    do
        echo -n "${word}."
    done
    echo ""
}

function example_for_03()
{
    echo "Iteracje podane:"
    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    do
        echo " Witam cię $i raz."
    done
    echo ""
}

function example_for_04()
{
    j=1
    echo "Dni tygodnia:"
    for day in Poniedziałek, Wtorek, Środa, Czwartek, Piatek, Sobota, Niedziela
    do
        echo "$day jest $((j++)) dniem"
    done
}

function example_for_05()
{
    j=1
    echo "Dni tygodnia:"
    for day in "Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piatek", "Sobota", "Niedziela"
    do
        echo "$day jest $((j++)) dniem"
    done
}

function example_for_06()
{
    # Iteracja operująca na zakresie.
    # Iteration operating on the range.
    echo "Zakres:"
    for i in {1..20}
    do
        echo " Witam cię $i raz."
    done
    echo ""
}

function example_for_07()
{
    # Iteracja operująca na zakresie z przeskokiem dostepna dopiero od wersji bash 4.
    # Iteration operating in the range with a jump available only from the bash 4 version.
    echo "Zakres z przeskokiem"
    echo "Wersja Bash: ${BASH_VERSION}..."
    for i in {1..20..2}
    do
        echo " Witam cię $i raz."
    done
    echo ""

    # Dla wersji bash 3.x+ można skorzystać z polecnia do sekwencji seq.
    # For the bash 3.x + version, you can use the command to the seq sequence.
    echo "Dla wersji bash 3.x+"
    for i in $(seq 1 2 20)
    do
        echo "Witam cię $i raz."
    done
    echo ""

    # Konstrkucja na styl C.
    # Constrution on style C.
    echo "Na styl C"
    for (( i=1; i<=20; i+=2; ))
    do
        echo " Witam cię $i raz."
    done
    echo ""
}

# while - wykonuje sie do puki warunek zwraca prawdę. w tym przypadku do puki jest mniejsze od 20
# while - do a condition, returns the truth. in this case, the number is less than 20
function example_while_01()
{
    count=1
    while [ $count -lt 20 ]
    do
        echo "Nasz licznik while: $count"
        ((count++))
    done
    echo ""
}


# until - wykonuje sie do puki warunek zwraca fałsz. Czyli nie spełnia postawionego warunku. W tym przypadku do puki nie bedzie wieksze niż 20
# until - it executes in the puka condition returns false. So it does not meet the condition. In this case, it will not be more than 20 in the band
function example_until_01()
{
    $count=1
    until [ $count -gt 20 ]
    do
        echo "Nasz licznik until: $count"
        ((count++))
    done
    echo ""
}

# break, continue - przerywanie, przeskakiwanie w petli.
# break, continue - interrupting, skipping in a loop.
function example_while_02()
{
    count=1
    while [ $count -le 20 ]
    do
        echo "Nasz licznik while: $count"
        ((count++))
        if [ $count -eq 10 ]; then
            break
        fi
    done
    echo ""
}

function example_until_2()
{
    $count=1
    until [ $count -gt 20 ]
    do
        
        
        if [ $count -eq 10 ]; then
            ((count++))
            continue 
        fi
        echo "Nasz licznik until: $count"
        ((count++))
    done
    echo ""
}

# select
function example_select_01()
{
options='Wersja Użytkownicy Grupy Wyjście'
PS3='Wybierz opcję: '

select option in $options
do
    if [ $option == 'Wyjście' ]
        break
    fi
    echo "Wybrałeś opcję $option"
done
echo "Pa Pa"
}

function main()
{

}
