all: src/golden.l
	clear
	flex src/golden.l
	gcc lex.yy.c -lfl
	./a.out