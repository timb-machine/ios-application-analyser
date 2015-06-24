all: dump_fileprotection

dump_fileprotection: dump_fileprotection.o 
	clang -o $@ $^ -isysroot /var/iPhoneOS7.1.sdk -framework Foundation

%.o: %.m
	clang -c -o $@ $< -isysroot /var/iPhoneOS7.1.sdk

clean:
	rm -f *.o dump_fileprotection
