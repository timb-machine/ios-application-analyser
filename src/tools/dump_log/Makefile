all: dump_log

dump_log: dump_log.o 
	clang -o $@ $^ -isysroot /var/iPhoneOS7.1.sdk -arch armv7 -arch arm64

%.o: %.c
	clang -c -o $@ $< -isysroot /var/iPhoneOS7.1.sdk -arch armv7 -arch arm64

clean:
	rm -f *.o dump_log
