all: dump_fileprotection

dump_fileprotection: dump_fileprotection.o 
	clang -o $@ $^ -isysroot /var/iPhoneOS7.1.sdk -arch armv7 -arch arm64 -framework Foundation

%.o: %.m
	clang -c -o $@ $< -isysroot /var/iPhoneOS7.1.sdk -arch armv7 -arch arm64

clean:
	rm -f *.o dump_fileprotection
