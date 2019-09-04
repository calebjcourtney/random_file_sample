import std.stdio;
import std.conv;
import std.random;


void  main(string[] args)
{
    if (args.length < 2)
    {
        writeln("you haven't provided enough arguments");
        return;
    }
    if (args[1] == "-h" || args[1] == "--help" || args[1] == "help")
    {
        writeln("I haven't written a help portion yet");
        return;
    }

    if (args.length < 3)
    {
        writeln("you haven't provided enough arguments");
        return;
    }

    double percent;

    try {
        percent = to!double(args[1]);
    }
    catch (std.conv.ConvException)
    {
        writeln("looks like your percent input wasn't a number. Try again.");
        return;
    }

    if (percent < 0.0 || percent > 1.0)
    {
        writeln("percent value out of range. should be a value between 0.0 and 1.0");
        return;
    }

    string inFileName = args[2];
    File inFile = File(inFileName, "r");

    auto rnd = Random(unpredictableSeed);
    double randomNum;

    if (args.length == 3)
    {
        while (!inFile.eof()) {
            string line = inFile.readln();
            randomNum = uniform!"()"(0.0f, 1.0f, rnd);

            if (randomNum <= percent)
                write(line);
        }
    }

    else {
        string outFileName = args[3];
        File outFile = File(outFileName, "w+");
        while (!inFile.eof()) {
            string line = inFile.readln();
            randomNum = uniform!"()"(0.0f, 1.0f, rnd);

            if (randomNum <= percent)
                outFile.write(line);
        }
    }
}