all: dumpdecrypted.dylib

dumpdecrypted.dylib: dumpdecrypted.o 
	clang -dynamiclib -o $@ $^ -isysroot /var/iPhoneOS7.1.sdk -arch armv7 -arch arm64

%.o: %.c
	clang -c -o $@ $< -isysroot /var/iPhoneOS7.1.sdk -arch armv7 -arch arm64

clean:
	rm -f *.o dumpdecrypted.dylib
