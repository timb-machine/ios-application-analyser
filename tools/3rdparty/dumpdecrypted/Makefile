all: dumpdecrypted.dylib

dumpdecrypted.dylib: dumpdecrypted.o 
	clang -dynamiclib -o $@ $^ -isysroot /var/iPhoneOS7.1.sdk

%.o: %.c
	clang -dynamiclib -c -o $@ $< -isysroot /var/iPhoneOS7.1.sdk

clean:
	rm -f *.o dumpdecrypted.dylib
