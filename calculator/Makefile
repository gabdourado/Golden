all: calc.l calc.y
	clear
	flex -i calc.l
	bison -d calc.y
	gcc calc.tab.c -lfl -lm
	./a.out