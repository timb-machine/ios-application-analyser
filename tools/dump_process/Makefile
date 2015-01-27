all: dump_process

dump_process: dump_process.o 
	clang -o $@ $^ -isysroot /var/iPhoneOS7.1.sdk
	ldid -SEntitlements.plist dump_process

%.o: %.c
	clang -c -o $@ $< -isysroot /var/iPhoneOS7.1.sdk

clean:
	rm -f *.o dump_process
