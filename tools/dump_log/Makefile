all: dump_log

dump_log: dump_log.o 
	clang -o $@ $^ -isysroot /var/iPhoneOS7.1.sdk

%.o: %.c
	clang -c -o $@ $< -isysroot /var/iPhoneOS7.1.sdk

clean:
	rm -f *.o dump_log
