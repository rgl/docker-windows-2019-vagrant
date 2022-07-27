using System.Collections;
using System.Text.RegularExpressions;
using Info;

DumpProgramCommandLine();
DumpProgramArguments(args);
DumpEnvironment();
DumpLoadedAssemblies();
DumpFiles();
DumpWhoAmI();

static void DumpProgramCommandLine()
{
    WriteTitle("Program Command Line");
    Console.WriteLine(Environment.CommandLine);
}

static void DumpProgramArguments(string[] args)
{
    if (args == null || args.Length == 0)
    {
        return;
    }

    WriteTitle("Program Arguments");
    foreach (var arg in args)
    {
        Console.WriteLine(arg);
    }
}

static void DumpEnvironment()
{
    WriteTitle("Environment Variables");
    foreach (var de in Environment.GetEnvironmentVariables().Cast<DictionaryEntry>().OrderBy(de => de.Key))
    {
        Console.WriteLine($"{de.Key}={de.Value}");
    }
}

static void DumpLoadedAssemblies()
{
    WriteTitle("Loaded Assemblies");
    foreach (var a in AppDomain.CurrentDomain.GetAssemblies().OrderBy(a => a.Location))
    {
        var match = Regex.Match(a.FullName ?? "", ".+ Version=(.+), Culture=.+");
        if (!match.Success)
        {
            continue;
        }
        Console.WriteLine($"{a.Location} {match.Groups[1]}");
    }
}

static void DumpFiles()
{
    WriteTitle("Files");
    foreach (var f in Directory.EnumerateFiles(Directory.GetCurrentDirectory()).OrderBy(f => f))
    {
        Console.WriteLine(f);
    }
}

static void DumpWhoAmI()
{
    var i = WhoAmI.GetWhoami();

    WriteTitle("Who Am I: User");
    Console.WriteLine(i.User);

    WriteTitle("Who Am I: Groups");
    foreach (var g in i.Groups.OrderBy(g => g.Account.ToString()))
    {
        Console.WriteLine($"{g.Account} {string.Join(",", g.Attributes)}");
    }

    WriteTitle("Who Am I: Privileges");
    foreach (var p in i.Privileges.OrderBy(g => g.Privilege))
    {
        Console.WriteLine($"{p.Privilege} {string.Join(",", p.Attributes)}");
    }
}

static void WriteTitle(string title)
{
    Console.WriteLine("#");
    Console.WriteLine($"# {title}");
    Console.WriteLine("#");
}
