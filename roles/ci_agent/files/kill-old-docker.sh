THRESHOLD=$(date --date "1 day ago" +%s)

docker ps --format "{{.ID}} {{.CreatedAt}}" | while read LINE; do
    ID=$(echo $LINE | awk '{print $1}');
    DATE=$(echo $LINE | awk '{print $2" "$3" "$4}');
    AGE=$(date --date "$DATE" +%s);
    if [ $AGE -lt $THRESHOLD ]; then
        docker rm --force $ID
    fi;
done