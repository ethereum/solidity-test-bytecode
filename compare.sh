#!/usr/bin/env bash

# MIT License
# Copyright (c) 2018 Contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions: The above copyright
# notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

set -e

# Check that the newest directory which has all files
# also has matching files.

files="emscripten.txt ubuntu-trusty-clang.txt ubuntu-trusty.txt windows.txt "
firstFile="${files%% *}"
for dir in $(ls -1 -d ???????????* | sort -r)
do
    cd "$dir"
    echo "Checking $dir..."
    existingFiles="$(ls -1 | tr '\n' ' ')"
    if [ "$existingFiles" = "$files" ]
    then
        # all files here
        (
        for f in $files
        do
            echo "Comparing $firstFile and $f..."
            diff "$firstFile" "$f"
        done
        )
        echo "All of them are equal!"
        break
    else
        # some files missing, complain if directory old
	if [[ "$dir" =~ ^$(date +"%Y-%m-%d") ]]
        then
            echo " -> Directory not complete, but also less than a day old."
	else
            echo "Some files missing (or surplus files)"
            echo "Files here:"
            ls
            echo "Expected files:"
            echo "$files"
            false
        fi
    fi
    cd ..
done
