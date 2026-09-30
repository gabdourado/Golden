all: golden

golden: src/golden.y src/golden.l
	flex -i -o src/lex.yy.c src/golden.l
	bison -d -o src/golden.tab.c src/golden.y
	gcc src/golden.tab.c src/symtab.c src/operations.c -o golden.out -lfl -lm

run: golden
	./golden.out < examples/example1.au

clean:
	rm -f golden src/lex.yy.c src/golden.tab.c src/golden.tab.h