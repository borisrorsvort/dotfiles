git diff --staged dots/brewfile.txt dots/brewcaskfile.txt | grep -E '^\+[^+]' | sed 's/^+//'
