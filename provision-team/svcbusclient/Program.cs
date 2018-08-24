// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

namespace SendCredentials
{
    using Microsoft.Azure.ServiceBus;
    using System;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;

    class Program
    {
        // Connection String for the namespace can be obtained from the Azure portal under the 
        // 'Shared Access policies' section.
        static IQueueClient queueClient;

        static void Main(string[] args)
        {
            string ServiceBusConnectionString;
            string QueueName;
            string MessageBody;

            Console.WriteLine(args.Length);

            try {

                ServiceBusConnectionString = args[0];
                QueueName = args[1];
                MessageBody = args[2];

                Console.WriteLine("Sending to queue " + QueueName);
                MainAsync(ServiceBusConnectionString, QueueName, MessageBody).GetAwaiter().GetResult();
            }
            catch (Exception exception)
            {
                Console.WriteLine($"{DateTime.Now} :: Exception: {exception.Message}");
            }
        }

        static async Task MainAsync(string ServiceBusConnectionString, string QueueName, string MessageBody)
        {
            queueClient = new QueueClient(ServiceBusConnectionString, QueueName);

            // Send Messages
            await SendMessagesAsync(MessageBody);

            await queueClient.CloseAsync();
        }

        static async Task SendMessagesAsync(string messageBody)
        {
            try
            {
                    // Create a new message to send to the queue
                    var message = new Message(Encoding.UTF8.GetBytes(messageBody));

                    // Write the body of the message to the console
                    Console.WriteLine($"Sending message: {messageBody}");

                    // Send the message to the queue
                    await queueClient.SendAsync(message);
            }
            catch (Exception exception)
            {
                Console.WriteLine($"{DateTime.Now} :: Exception: {exception.Message}");
            }
        }
    }
}