find ../ -type f -name '*.vhd' > file.txt

c="load_library tsmc035_typ"
s="read -dont_elaborate {"
while IFS='' read -r line || [[ -n "$line" ]]; do
    s="$s\"$line\" "
done < file.txt
s="$s}"
echo $c > command.txt
echo $s >> command.txt
rm file.txt
