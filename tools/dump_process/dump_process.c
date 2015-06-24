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

(c) Tim Brown, 2015
<mailto:timb@nth-dimension.org.uk>
<http://www.nth-dimension.org.uk/> / <http://www.machine.org.uk/>

Greets to @_frego_ and @osxreverser who inspired this tool
*/

#include <stdlib.h>
#include <mach/mach.h>
#include <string.h>
#include <stdio.h>

#define DUMPSIZE 4096

extern kern_return_t mach_vm_region(vm_map_t taskport, mach_vm_address_t *regionaddress, mach_vm_size_t *regionsize, vm_region_flavor_t regionflavor, vm_region_info_t regioninfo, mach_msg_type_number_t *messagetype, mach_port_t *objectport);
extern kern_return_t mach_vm_read_overwrite(vm_map_t taskport, mach_vm_address_t regionaddress, mach_vm_size_t regionsize, mach_vm_address_t regionbuffer, mach_vm_size_t *regionlength);

int main(int argc, char **argv) {
	/* TODO clean up stack order */
	pid_t processid;
	mach_port_t taskport;
	mach_vm_address_t regionaddress;
	mach_port_t objectport;
	mach_vm_size_t regionsize;
	mach_msg_type_number_t countmessage;
	vm_region_basic_info_data_t regioninfo;
	mach_vm_size_t regioncounter;
	void *regionbuffer;
	mach_vm_size_t regionlength;
	char *filename;
	FILE *filehandle;
	if (argc == 2) {
		processid = atoi(argv[1]);
		if (task_for_pid(mach_task_self(), processid, &taskport) == KERN_SUCCESS) {
			while (1) {
				regionaddress += regionsize;
				countmessage = VM_REGION_BASIC_INFO_COUNT_64;
				if (mach_vm_region(taskport, &regionaddress, &regionsize, VM_REGION_BASIC_INFO, (vm_region_info_t) &regioninfo, &countmessage, &objectport) != KERN_SUCCESS) {
					goto cleanup;
				}
				filename = calloc(5 + strlen(argv[1]) + 1 + 16 + 1, sizeof(char));
				/* TODO check that this succeeds */
				sprintf(filename, "dump-%i-%.16lx", processid, (uintptr_t) regionaddress);
				filehandle = fopen(filename, "wb");
				/* TODO check that this succeeds */
				for (regioncounter = 0; regioncounter <= regionsize - DUMPSIZE - (regionsize % DUMPSIZE); regioncounter += DUMPSIZE) {
					regionbuffer = calloc(DUMPSIZE, sizeof(char));
					/* TODO check that this succeeds */
					mach_vm_read_overwrite(taskport, regionaddress + regioncounter, DUMPSIZE, (mach_vm_address_t) regionbuffer, &regionlength);
					/* TODO check that this succeeds */
					fwrite(regionbuffer, regionlength, 1, filehandle);
					free(regionbuffer);
				}
				if (regioncounter < regionsize) {
					regionbuffer = calloc(regionsize - regioncounter, sizeof(char));
					/* TODO check that this succeeds */
					mach_vm_read_overwrite(taskport, regionaddress + regioncounter, regionsize - regioncounter, (mach_vm_address_t) regionbuffer, &regionlength);
					/* TODO check that this succeeds */
					fwrite(regionbuffer, regionlength, 1, filehandle);
					free(regionbuffer);
				}
				fclose(filehandle);
				free(filename);
			}
		}
		cleanup:
			if (taskport != MACH_PORT_NULL) {
				mach_port_deallocate(mach_task_self(), taskport);
			}
			exit(EXIT_SUCCESS);
	} else {
		exit(EXIT_FAILURE);
	}
}
