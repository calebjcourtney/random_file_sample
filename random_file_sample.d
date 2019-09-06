import std.stdio;
import std.conv;
import std.random;
import std.datetime.systime : SysTime, Clock;
import std.algorithm : canFind, countUntil;


int countLines(string fileName)
{
    int x = 0;
    File readFile = File(fileName, "r");
    string line;
    while (!readFile.eof()) {
        line = readFile.readln();

        ++x;
    }

    return x;
}


void  main(string[] args)
{
    // Validating the Args

    // help
    if (args.canFind("-h") || args.canFind("--help"))
    {
        writeln("I haven't written a help portion yet");
        return;
    }

    // if they aren't asking for help, then 3 args is still not enough
    if (args.length < 3)
    {
        writeln("you haven't provided enough arguments");
        return;
    }

    float percent = 0.0;
    double lineCount = 0;

    // percent
    if (args.canFind("-p"))
    {
        try {
            percent = to!float(args[countUntil(args, "-p") + 1]);
        }
        catch (std.conv.ConvException)
        {
            writeln("your percent input wasn't a number");
            return;
        }
    }
    // line count - this is much slower
    else if (args.canFind("-n"))
    {
        try {
            lineCount = to!double(args[countUntil(args, "-n") + 1]);
        }
        catch (std.conv.ConvException)
        {
            writeln("your line count wasn't a number");
            return;
        }
    }
    else
    {
        writeln("you need to include at least one of -p or -n");
        return;
    }

    // ensure that percent is between 0 and 1 in value
    if (percent < 0.0 || percent > 1.0)
    {
        writeln("percent value out of range. should be a float from 0.0 to 1.0");
        return;
    }

    // this means we don't have to do anything and should just complete
    if (percent == 0.0 && lineCount == 0)
        return;

    // should add a feature allowing them to be used together. not sure how this would be implemented though
    if (percent > 0 && lineCount > 0)
    {
        writeln("percent and line count can't be used together");
        return;
    }

    string inFileName;

    if (args.canFind("--inputFile"))
    {
        inFileName = args[countUntil(args, "--inputFile") + 1];
    }
    else if (args.canFind("-i"))
    {
        inFileName = args[countUntil(args, "-i") + 1];
    }
    else
    {
        writeln("no `--inputFile` specified");
        return;
    }

    int inFileLineCount;

    if (lineCount > 0)
    {
        inFileLineCount = countLines(inFileName);
        percent = to!float(lineCount) / to!float(inFileLineCount);
    }

    if (percent > 1)
    {
        writeln("line count is greater than number of lines of inputFile");
        return;
    }

    // End args validation - now the real work can begin

    File inFile = File(inFileName, "r");

    SysTime currentTime = Clock.currTime();

    auto rnd = Random(currentTime.second + currentTime.minute + currentTime.hour);
    double randomNum;

    string outFileName = "";

    if (args.canFind("-o"))
    {
        outFileName = args[countUntil(args, "-o") + 1];
    }
    else if (args.canFind("--outputFile"))
    {
        outFileName = args[countUntil(args, "--outputFile") + 1];
    }

    double modifier;

    /*
    1. Keep track of the number of lines we've output, 
    2. when we reach that number, we need to stop outputting
    3. Iterate through all the lines of the file, generating a new random value betwen 0 and 1 for each line
    4. `modifier` tracks the status of how many lines we've output, how many lines we are supposed to output, and how many lines are left.
    5. modifier then influences `percent` to raise or lower the likelihood of line being in output
    6. If the random number is less than the modified percentage, then we output the line
    */

    if (lineCount > 0)
    {
        int counter;
        int linesLeft = to!int(lineCount);

        if (outFileName == "")
        {
            while (!inFile.eof() && counter < lineCount) {
                string line = inFile.readln();
                randomNum = uniform!"()"(0.0f, 1.0f, rnd);

                modifier = percent * ((to!double(lineCount) - to!double(counter)) / to!double(linesLeft));

                if (randomNum <= percent + modifier)
                {
                    write(line);
                    ++counter;
                }

                --linesLeft;
            }
        }

        else {
            File outFile = File(outFileName, "w+");
            while (!inFile.eof() && counter < lineCount) {
                string line = inFile.readln();
                randomNum = uniform!"()"(0.0f, 1.0f, rnd);

                modifier = percent * ((to!double(lineCount) - to!double(counter)) / to!double(linesLeft));

                if (randomNum <= percent + modifier)
                {
                    outFile.write(line);
                    ++counter;
                }

                --linesLeft;
            }
        }
    }

    /*
    1. We don't keep track of the number of records or a modifier this time, so the process is overall faster
    2. Generate a random float between 0 and 1 for each line
    3. If the float is less than our percent benchmark, then output the given line
    */
    else
    {
        if (outFileName == "")
        {
            while (!inFile.eof()) {
                string line = inFile.readln();
                randomNum = uniform!"()"(0.0f, 1.0f, rnd);

                if (randomNum <= percent)
                    write(line);
            }
        }

        else {
            File outFile = File(outFileName, "w+");
            while (!inFile.eof()) {
                string line = inFile.readln();
                randomNum = uniform!"()"(0.0f, 1.0f, rnd);

                if (randomNum <= percent)
                    outFile.write(line);
            }
        }
    }
}