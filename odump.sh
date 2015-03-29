#!/bin/bash
# Organize exit the objdump
# Autor: Slack
# Date: 24/03/2015
# version 1.4
# ld -s hello.o bar.o -o foobar
# Var COUNT -1 because in C, strlen () starts counting from zero, wc -l starts counting from one

	# Test
	if [[ "$#" < 2 ]]; then
		echo "Usage: `basename $0` {-p|-s|-ps} filename.o"
		echo "-p for print"
                echo "-s just save"
                echo "-ps save and print"
		exit 1
	fi

	if ! [[ "$2" =~ .o$ ]]; then
		echo "Please check the argument "foo.o""
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
save () {
	test -e "$2.txt" || touch "$2.txt"
	echo "$ORGANIZE" > "$OUT"
	echo "Length: $(expr "$COUNT" - 1 )" && echo "Length: $(expr "$COUNT" - 1 )" >> "$OUT"
	}


print () {
	echo
	echo "**********Shellcode***********"
	echo "$ORGANIZE"
	echo "**********Shellcode***********"
	echo
	echo "Length: $(expr "$COUNT" - 1 )"
	echo
	}

	case "$1" in
		-p)
		    print
		;;

		-s)
		    save
       		    echo "Shellcode organized save in "$OUT""
		;;

		-ps)
		   save 
		   print
		;;

		*)
		   echo "Usage: `basename $0` {-p|-s|-ps} filename.o"
		   echo "-p for print"
	           echo "-s just save"
	           echo "-ps save and print"
		   exit 1
	esac
