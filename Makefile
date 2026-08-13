all: src/golden.l
	clear
	flex -i src/golden.l
	gcc lex.yy.c -lfl
	./a.out