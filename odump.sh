#!/bin/bash
# Organize exit the objdump
# Autor: Slack
# Date: 24/03/2015
# Update: 02/06/2015
# version 1.6
# ld -s hello.o bar.o -o foobar
# Var COUNT -1 because in C, strlen () starts counting from zero, wc -l starts counting from one

	# Test
	if [[ "$#" -lt 2 ]]; then
		echo "Usage: $(basename "$0") {-p|-s|-ps} filename.o"
		echo "-p for print"
                echo "-s just save"
                echo "-ps save and print"
		exit 1
	fi

	if ! [[ "$2" =~ .o$ ]]; then
		echo "Please check the argument foo.o"
		echo "nasm -f elf foo.asm -o foo.o"
		exit 1
	fi

	if [[ -z "$(type -p objdump)"  || -z "$(type -p nasm)" ]]; then
		echo "Obs: Objdump or Nasm -- NOT INSTALLED!!"
		exit 1
	fi


	# Vars
	ASM="$2"
	ORGANIZE="$(objdump -d "$ASM" | egrep -v "[0-9]{8}\s<" | egrep -o "([0-9a-f]{2}\s){1,5}" | sed -e 's/^/"\\x/' -e 's/\s/\\x/g' -e 's/\\x$/"/g')"
	COUNT="$(objdump -d "$ASM" | egrep -v "[0-9]{8}\s<"  | egrep -o "([0-9a-f]{2}\s){1,5}" | wc -l)"
	OUT="$2.txt"

	# Working
function save() {
	test -e "$2.txt" || touch "$2.txt"
	echo "$ORGANIZE" > "$OUT"
	echo "Length: $((COUNT - 1 ))" 
	echo "Length: $((COUNT -1 ))" >> "$OUT"
	
	}


function print() {
	echo
	echo "**********Shellcode***********"
	echo "$ORGANIZE"
	echo "**********Shellcode***********"
	echo
	echo -e "Length: $((COUNT -1 ))"
	echo
	}

	case ${1} in
		-p)
		    print "$1"
		;;

		-s)
		    save "$1"
       		    echo "Shellcode organized save in ${OUT}"
		;;

		-ps)
		   save "$1"
		   print "$1"
		;;

		*)
		   echo "Usage: $(basename "$0") {-p|-s|-ps} filename.o"
		   echo "-p for print"
	           echo "-s just save"
	           echo "-ps save and print"
		   exit 1
	esac
