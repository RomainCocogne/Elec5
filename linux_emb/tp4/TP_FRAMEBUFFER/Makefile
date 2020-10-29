all: test


test: videodisplay.o 
	gcc -Wall  videodisplay.o -o test

videodisplay.o: videodisplay.c
	gcc -Wall -c $(CCOPT) videodisplay.c

clean:
	rm -rf *o test
