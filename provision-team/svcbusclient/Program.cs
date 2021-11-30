// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

namespace SendCredentials
{
    using System;
    using System.IO;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using System.Runtime.Serialization;
    using Azure.Messaging.ServiceBus;
    using Newtonsoft.Json;

    class Program
    {
        // Connection String for the namespace can be obtained from the Azure portal under the 
        // 'Shared Access policies' section.
        static ServiceBusSender sender;

        static void Main(string[] args)
        {
            string ServiceBusConnectionString;
            string QueueName;
            string recipientEmail;
            string MessageBody;

            Console.WriteLine(args.Length);

            try {

                ServiceBusConnectionString = args[0];
                QueueName = args[1];
                recipientEmail = args[2];
                MessageBody = args[3];

                Console.WriteLine("Sending to queue " + QueueName);
                MainAsync(ServiceBusConnectionString, QueueName, recipientEmail, MessageBody).GetAwaiter().GetResult();
            }
            catch (Exception exception)
            {
                Console.WriteLine($"{DateTime.Now} :: Exception: {exception.Message}");
            }
        }

        static async Task MainAsync(string ServiceBusConnectionString, string QueueName, string recipientEmail, string MessageBody)
        {
            Console.WriteLine($"mainAsync");
            ServiceBusClient client = new ServiceBusClient(ServiceBusConnectionString);
            sender = client.CreateSender(QueueName);
            Console.WriteLine($"before send ansync");
            // Send Messages
            await SendMessagesAsync(recipientEmail, MessageBody);

            await sender.CloseAsync();
        }

        static async Task SendMessagesAsync(string recipientEmail, string messageBody)
        {
            //Random rnd = new Random();
            try
            {
                Console.WriteLine($"SendMessagesAsync");
                    // Create a new message to send to the queue
                    var message = new Dictionary<string, string>
                    {
                        { "ReceiverEmail", recipientEmail },
                        { "Message", messageBody }
                    };

                    string data = JsonConvert.SerializeObject(message);

                    ServiceBusMessage sendMessage = new ServiceBusMessage(data);

                    await sender.SendMessageAsync(sendMessage);


            }
            catch (Exception exception)
            {
                Console.WriteLine($"{DateTime.Now} :: Exception: {exception.Message}");
            }
        }
    }
}