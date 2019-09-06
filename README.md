# random_file_sample
Outputs a random sample of a given input file, based on a percent input by the user

Written on Ubuntu 19.04 using DMD64 D Compiler v2.087.0

System settings:
```
OS: Ubuntu 19.04
Processor: Intel® Xeon(R) E-2176M CPU @ 2.70GHz × 12 
OS type: 64-bit
```

Ran on a 28GB .jsonl file with the following results:

```
$ wc -l lichess_db.jsonl
36695223 lichess_db.jsonl

$ time rdmd random_file_sample.d -p 0.01 -i lichess_db.jsonl -o lichess_db_sample.jsonl 
real	0m26.739s
user	0m19.781s
sys	0m13.423s

$ wc -l lichess_db_sample.jsonl 
367365 lichess_db_sample.jsonl

$ time rdmd random_file_sample.d -n 367365 -i lichess_db.jsonl -o lichess_db_sample.jsonl 
real	0m53.344s
user	0m38.923s
sys	0m29.846s

$ wc -l lichess_db_sample.jsonl 
367365 lichess_db_sample.jsonl
```

When specifying the number of lines, the program takes twice as long to run, since it iterates over the file twice in the entire process.

## Run
You can specify a sample based on percent (`-p`) or line count (`-n`):
`rdmd random_file_sample.d -p <percent> -i <inputfile> -o <outputfile>`
`rdmd random_file_sample.d -n <linecount> -inputFile <inputfile> -outputFile <outputfile>`

If you want it written to stdout, you can leave off the `-outputFile`:
`rdmd random_file_sample.d -p <percent> -i <inputfile>`
`rdmd random_file_sample.d -n <linecount> -inputFile <inputfile>`
