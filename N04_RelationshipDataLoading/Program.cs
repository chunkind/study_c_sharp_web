﻿using N02_CRUD;
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
            Console.WriteLine("[1] Eager Loading"); // 즉시
            Console.WriteLine("[2] Explicit Loading"); // 명시적
            Console.WriteLine("[3] Select Loading"); // 선택적

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
                        DbCommands.EagerLoading();
                        break;
                    case "2":
                        DbCommands.ExplicitLoading();
                        break;
                    case "3":
                        DbCommands.SelectLoading();
                        break;
                }
            }
        }
    }
}