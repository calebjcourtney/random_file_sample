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
$ time random_file_sample 0.01 lichess_db.jsonl sample_lichess_db.jsonl
real	0m36.141s
user	0m19.596s
sys	0m16.997s
```

## Run
You can specify a sample based on percent (`-p`) or line count (`-n`):
`rdmd random_file_sample.d -p <percent> -i <inputfile> -o <outputfile>`
`rdmd random_file_sample.d -n <linecount> -inputFile <inputfile> -outputFile <outputfile>`

If you want it written to stdout, you can leave off the `-outputFile`:
`rdmd random_file_sample.d -p <percent> -i <inputfile>`
`rdmd random_file_sample.d -n <linecount> -inputFile <inputfile>`
