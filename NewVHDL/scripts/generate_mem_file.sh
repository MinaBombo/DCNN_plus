value=1;
echo $value > memory.list;
for i in {1..262143}
do
	value=1;
	echo $value>> memory.list;
done;
