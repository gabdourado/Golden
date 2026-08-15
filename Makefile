all: src/golden.y src/golden.l
	clear
	bison -d src/golden.y -o src/golden.tab.c
	flex -o src/lex.yy.c src/golden.l
	gcc src/golden.tab.c src/lex.yy.c -lfl
	./a.out