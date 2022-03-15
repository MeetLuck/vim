
let marks = execute('marks 0ABCDEFGHIJKLMNOPQRSTUVWXYZ.')
echo "marks ->"
echo marks[1]
echo marks[2]
echo marks[3]
let lines = split(marks,"\n")
echo "lines ->"
echo lines[1]
echo lines[2]
echo lines[3]
for line in lines
    echo "line ->"
    echo line
    echo "splitline ->"
    echo split(line,"\W+")
endfor
