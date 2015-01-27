all: dump_process

dump_process: dump_process.o 
	clang -o $@ $^ -isysroot /var/iPhoneOS8.1.sdk -arch armv7 -arch arm64
	ldid -SEntitlements.plist dump_process

%.o: %.c
	clang -c -o $@ $< -isysroot /var/iPhoneOS8.1.sdk -arch armv7 -arch arm64

clean:
	rm -f *.o dump_process
