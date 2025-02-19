using N02_CRUD;
using System;

namespace MMO_EFCore
{
    class Program
    {
        static void Main(string[] args)
        {
            DbCommands.InitializeDB(forceReset: false);

            // CRUD
            Console.WriteLine("명령어를 입력하세요");
            Console.WriteLine("[0] ForceReset");
            Console.WriteLine("[1] UpdateTest");
            Console.WriteLine("[2] Update (Reload)");
            Console.WriteLine("[3] Update (Full)");

            while(true)
            {
                Console.Write("> ");
                string command = Console.ReadLine();
                switch(command)
                {
                    case "0":
                        DbCommands.InitializeDB(forceReset: true);
                        break;
                    case "1":
                        DbCommands.UpdateByReload();
                        break;
                    case "2":
                        DbCommands.UpdateByFull();
                        break;
                    case "3":
                        break;
                }
            }
        }
    }
}