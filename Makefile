examples:
	./qplot -d testdata/free-memory.txt.dat -t dumb -x 130 -y 50

.PHONY: testdata
testdata:
	bzcat testdata/atop.json.bz2 | jq -r '[.timestamp, .CPL.lavg15] | @tsv' > testdata/cpu-load-with-timestamp.dat
	bzcat testdata/atop.json.bz2 | jq -r '.MEM.freemem' | awk '{print NR "\t" $$0}' > testdata/free-memory-indexed.dat
	bzcat testdata/atop.json.bz2 | jq '.DSK[0] | .nread + .nwrite' | tail -n +2 > testdata/iops-no-index
	bzcat testdata/atop.json.bz2 | jq '.PRG[] | select(.name == "(paladin-worker)") | .pid' | sort -u > testdata/paladin-threads.txt
	jq -s '.' testdata/paladin-threads.txt > testdata/paladin-threads.json
	bzcat testdata/atop.json.bz2 | jq -r --slurpfile foo testdata/paladin-threads.json '.timestamp as $ts | .PRC[] | select(.pid as $pid | $foo[0] | index($pid)) | [$ts, .pid, .utime] | @tsv' > testdata/paladin-utime.tsv
	cat testdata/paladin-utime.tsv | awk -f pivot.awk  > testdata/paladin-utime.pivoted.tsv

