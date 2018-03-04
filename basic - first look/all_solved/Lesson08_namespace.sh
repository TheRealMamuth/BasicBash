#!/bin/bash -       
#title           : Lesson08_namespace
#description     : The use of namespace on the example of a script
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

# [PL]
# Lekcja 8 - na moim kanale pojawił się film o namespace (link: https://www.youtube.com/watch?v=cOOCJjNKwRQ)
#       W filmie tym tworzyłem namespace recznie.
#       
#       W tej lekci spróbujemy tworzenie namespace sobie zautomatyzować.
#       Zadanie:
#           1. Tworzymy skrypt tworzący w systemie linux namespace.
#           2. Skrypt nas nie ogranicza - możemy stworzyć ile chcemy namespace (oczywiście bez przesady :) nie odpowiadam za uszkodenia systemu;))
#           3. Możemy indywidualnie zarządzać utworzonymi namespace.
#           4. Możemy podpiąć dowolny interfejs sieciowy.
#           5. Mamy możliwość nadania adresu ip każdemu z tych namespace.
#           6. Mozemy wykonać każdą komende w konteksiec namespoace.
#           7. Możemy zwolnić nasz interfejs
#           8. Wykorzystamy oprogramowanie openvswitch do komunikacji miedzy namespace a nasza siecia maszyną virtualną z systemem Linux.
#           9. Zadanie bonusowe - stworzyc funkcje instalująca nasz pakiet openvswitch-switch

# [ENG]
# Lesson 8 - a movie about namespace appeared on my channel (link: https://www.youtube.com/watch?v=cOOCJjNKwRQ)
# In the movie, I created namespace manually.
#
# In this lesson, we will try to create namespace to automate.
# Task:
# 1. We create a script creating in the linux namespace system.
# 2. The script does not limit us - we can create how many namespace we want (of course without exaggeration :) I am not responsible for system damage;))
# 3. We can individually manage created namespaces.
# 4. We can connect any network interface.
# 5. We have the option of giving an ip address to each of these namespace.
# 6. We can execute any command in the namespoace domain.
# 7. We can release our interface
# 8. We will use openvswitch software for communication between namespace and our network with a virtualna machine with Linux.
# 9. Bonus task - create a function that installs our openvswitch-switch package

# BEGIN -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

. ../mylib/mnamespace.sh

main

# END -------------------------------------------------------------------------------------------------------------------------------------------------------------------------