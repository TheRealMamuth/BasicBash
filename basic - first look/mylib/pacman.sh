#!/bin/bash -       
#title           : pacman
#description     : Very simple package manager
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

function pacman()
{
    local pacman=$1
    sudo $1 update
    sudo $1 install $2
}