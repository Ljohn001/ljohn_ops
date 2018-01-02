#!/bin/bash

read -p "Enter a word: " word

while [[ "$word" != "quit" ]]; do
	echo $word | tr 'a-z' 'A-Z'
	read -p "Enter a word again: " word
done
