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
            Console.WriteLine("[1] ReadAll");
            Console.WriteLine("[2] ShowItems");

            while(true)
            {
                Console.WriteLine("> ");
                string command = Console.ReadLine();
                switch(command)
                {
                    case "0":
                        DbCommands.InitializeDB(forceReset: true);
                        break;
                    case "1":
                        DbCommands.ReadAll();
                        break;
                    case "2":
                        DbCommands.ShowItems();
                        break;
                    case "3":
                        break;
                }
            }
        }
    }
}