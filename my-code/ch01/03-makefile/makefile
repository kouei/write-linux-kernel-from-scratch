OBJS := foo.o bar.o
CC := gcc
CFLAGS := -O2

# $@ means the first target in current rule, which is a.out
# $^ means all prerequisites in current rule, which is $(OBJS)
a.out: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@      

# $< means the first prerequisite in current rule, which is foo.c
foo.o: foo.c
	$(CC) $(CFLAGS) $< -c -o $@

# $? means all prerequisites in current rule that are newer than target.
bar.o: bar.c
	$(CC) $(CFLAGS) $? -c -o $@

.PHONY: clean
clean:
	rm -f a.out $(OBJS)