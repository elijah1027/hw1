filename='name.txt'
filelines=`cat $filename`
directory=taq.12.2014/

for line in $filelines ; do
    #echo $line
    locate_dir=$'s3://'$directory$line
    sudo aws s3 cp $locate_dir ./temp.zip;
    name_file="$(unzip -l temp.zip | awk '/-----/ {p = ++p % 2; next} p {print $NF}')";
    date=${name_file:(-8)}
    echo $date
    unzip temp.zip;
    rm -f temp.zip;
    head -n 5000 $name_file  > tmp_file;
    mv tmp_file $name_file
    sed  '1 d' $name_file | sed 's/[^[:alnum:]]\+$//;s/ \{1,\}/,/g' | sed 's/,/-/2g' |  sed "s/$/,$date/g"| sed '1i A,B,C'| sed $'s/\r$//' | sed '/^$/d' > $date.txt
done

