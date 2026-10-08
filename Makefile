all: build/golden.out

build/golden.out: src/parser/golden.y src/parser/golden.l src/symtab/symtab.c src/operations/operations.c src/io/io.c
	mkdir -p build
	flex -i -o build/lex.yy.c src/parser/golden.l
	bison -d -o build/golden.tab.c src/parser/golden.y
	gcc -Isrc build/golden.tab.c src/symtab/symtab.c src/operations/operations.c src/io/io.c -o build/golden.out -lfl -lm

run: build/golden.out
	./build/golden.out examples/example5.au

clean:
	rm -rf build