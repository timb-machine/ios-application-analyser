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

. lib/misc/stdio

header () {
	VERSION="0.2"
	SVNVERSION="$Revision$" # Don't change this line.  Auto-updated.
	SVNVNUM="$(echo "${SVNVERSION}" | sed "s/[^0-9]//g")"
	if [ -n "${SVNVNUM}" ]; then
		VERSION="${VERSION}-svn-${SVNVNUM}"
	fi
	printf "ios-application-analyser v%s\n\n" "${VERSION}"
}

version () {
	header
	preamble
	printf "Brought to you by:\n"
	cat doc/AUTHORS
	exit 1
}

preamble () {
	printf "Shell script to analyse iOS applications.\n\n"
}

usage () {
	header
	preamble
	printf "Usage: %s\n" "${0}"
	printf "\n"
	printf "\t--help\tdisplay this help and exit\n"
	printf "\t--version\tdisplay version and exit\n"
	printf "\t--color\tenable output coloring\n"
	printf "\t--verbose\tverbose level (0-2, default: 1)\n"
	printf "\t--type\tselect from one of the following check types:\n"
	for checktype in lib/checks/enabled/*
	do
		printf "\t\t%s\n" "$(basename "${checktype}")"
	done
	printf "\t--checks\tprovide a comma separated list of checks to run, select from the following checks:\n"
	for check in lib/checks/*
	do
		if [ "$(basename "${check}")" != "enabled" ]
		then
			printf "\t\t%s\n" "$(basename "${check}")"
		fi
	done
	printf "\t--filename\tfilename of binary\n"
	printf "\t--directorypath\tdirectory path to application data\n"
	exit 1
}

# TODO make it use lib/misc/validate
TYPE="post-install"
CHECKS=""
COLORING="0"
VERBOSE="1"
while [ -n "${1}" ]
do
	case "${1}" in
		--help|-h)
			usage
			;;
		--version|-v|-V)
			version
			;;
		--color)
			COLORING="1"
			;;
		--verbose)
			shift
			VERBOSE="${1}"
			;;
		--type|-t)
			shift
			TYPE="${1}"
			;;
		--checks|-c)
			shift
			CHECKS="${1}"
			;;
		--filename|-f)
			shift
			FILENAME="${1}"
			;;
		--directorypath|-d)
			shift
			DIRECTORYPATH="${1}"
			;;
	esac
	shift
done
header
if [ "${VERBOSE}" != "0" -a "${VERBOSE}" != "1" -a "${VERBOSE}" != "2" ]
then
	stdio_message_error "iaa" "the provided verbose level ${VERBOSE} is invalid - use 0, 1 or 2 next time"
	VERBOSE="1"
fi
if [ -n "${CHECKS}" ]
then
	for checkfilename in $(printf "%s" "${CHECKS}" | tr -d " " | tr "," " ")
	do
		if [ ! -e "lib/checks/${checkfilename}" ]
		then
			stdio_message_error "iaa" "the provided check name \"${checkfilename}\" does not exist"
		else
			. "lib/checks/${checkfilename}"
			"$(basename "${checkfilename}")_init"
			"$(basename "${checkfilename}")_main"
			"$(basename "${checkfilename}")_fini"
		fi
	done
else
	if [ ! -d "lib/checks/enabled/${TYPE}" ]
	then
		stdio_message_error "iaa" "the provided check type \"${TYPE}\" does not exist"
	else
		for checkfilename in lib/checks/enabled/${TYPE}/*
		do
			. "${checkfilename}"
			"$(basename "${checkfilename}")_init"
			"$(basename "${checkfilename}")_main"
			"$(basename "${checkfilename}")_fini"
		done
	fi
fi
exit 0
