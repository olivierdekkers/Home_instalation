# Show a filtered list of files where the parameter is found.
list_occurrences() {

	grep -rc $1 | grep -v :0

}

# Count the number of occurrences of the passed string.
count_occurrences() {
	
	find . -maxdepth 2 -type f -exec cat {} + | grep -c $1
}

# Find text passed and replaces it by the second parameter.

replace_text() {

	grep -rlZ $1 | xargs -0 sed -i -e 's/'$1'/'$2'/g'
}
