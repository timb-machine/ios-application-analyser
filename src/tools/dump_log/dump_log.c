/*
$Revision$

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
* Neither the name of the Nth Dimension nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

(c) Tim Brown, 2014
<mailto:timb@nth-dimension.org.uk>
<http://www.nth-dimension.org.uk/> / <http://www.machine.org.uk/>
*/

#include <asl.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	aslmsg aslquery;
	aslresponse aslresponse;
	aslmsg aslmessage;
	char *aslmessagestring;
	int loopcounter;
	const char *keystring;
	aslquery = asl_new(ASL_TYPE_QUERY);
	aslresponse = asl_search(NULL, aslquery);
	while ((aslmessage = aslresponse_next(aslresponse)) != NULL) {
		if (argc == 2) {
			if (strstr(asl_get(aslmessage, "Sender") , argv[1])) {
				printf("%s\n", asl_get(aslmessage, "Message"));
			}
		} else {
			loopcounter = 0;
			while ((keystring = asl_key(aslmessage, loopcounter)) != NULL) {
				printf("%s: %s\n", keystring, asl_get(aslmessage, keystring));
				loopcounter ++;
			}
		}
	}
	aslresponse_free(aslresponse);
	exit(EXIT_SUCCESS);
}
