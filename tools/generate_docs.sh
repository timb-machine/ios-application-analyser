#!/bin/sh
# $Revision$
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# * Neither the name of the Nth Dimension nor the names of its contributors may
# be used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# (c) Tim Brown, 2014
# <mailto:timb@nth-dimension.org.uk>
# <http://www.nth-dimension.org.uk/> / <http://www.machine.org.uk/>

FILENAME="${1}"

if [ -f "${FILENAME}" ]
then
	filelength="$(wc -l "${FILENAME}" | awk '{ print $1 }')"
	codechunk="$((${filelength} - 30))"
	printf "h1. %s\n" "${FILENAME}"
	printf "\n";
	tail -n "${codechunk}" "${FILENAME}" | sed "s/%/%%/g" | while read line
	do
		if [ -n "$(printf "%s" "${line}" | egrep "^\.")" ]
		then
			filename="$(printf "%s" "${line}" | sed -e "s/\. //g")"
			printf "Depends on: %s\n" "$(printf "%s" "${filename}")"
			printf "\n"
		fi
		if [ -n "$(printf "%s" "${line}" | egrep "() {")" ]
		then
			functionname="$(printf "%s" "${line}" | sed -e "s/ () {//g")"
			printf "h2. %s()\n" "${functionname}"
			printf "\n"
		fi
		if [ -n "$(printf "%s" "${line}" | egrep "binary_matches_api")" ]
		then
			searchstring="$(printf "%s" "${line}" | cut -f 3 -d " " | cut -f 2 -d "\"")"
			printf "	< %s\n" "${searchstring}"
		fi
		if [ -n "$(printf "%s" "${line}" | egrep "=\".{[1-9]}")" ]
		then
			variablename="$(printf "%s" "${line}" | cut -f 1 -d "=")"
			printf "    < %s\n" "${variablename}"
			printf "\n"
		fi
		if [ -n "$(printf "%s" "${line}" | egrep "#" | egrep -v "^#$")" ]
		then
			if [ -n "$(printf "%s" "${line}" | egrep "#" | egrep -v "^#$" | egrep "TODO")" ]
			then
				commentstring="$(printf "%s" "${line}" | sed -e "s/.*# //g" -e "s/TODO //g" -e "s/%/%%/g")"
				printf "      <TODO>\n"
				printf "        %s\n" "${commentstring}"
				printf "      </TODO>\n"
				printf "\n";
			else
				commentstring="$(printf "%s" "${line}" | sed -e "s/.*# //g")"
				printf "      <comment>\n"
				printf "        %s\n" "${commentstring}"
				printf "      </comment>\n"
				printf "\n";
			fi
		fi
		if [ -n "$(printf "%s" "${line}" | egrep "error")" ]
		then
			errorstring="$(printf "%s" "${line}" | cut -f 4 -d "\"")"
			printf "      <error>\n"
			printf "        %s\n" "${errorstring}"
			printf "      </error>\n"
			printf "\n"
		fi	
	done
fi
