//----------------------------------------------------------------------------------
// Microsoft Developer & Platform Evangelism
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
//----------------------------------------------------------------------------------
// The example companies, organizations, products, domain names,
// e-mail addresses, logos, people, places, and events depicted
// herein are fictitious.  No association with any real company,
// organization, product, domain name, email address, logo, person,
// places, or events is intended or should be inferred.
//----------------------------------------------------------------------------------

namespace UploadMusic
{
    using Microsoft.Azure;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;
    using System;
    using System.Data.SqlClient;
    using System.IO;
    public class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 3)
            {
                Console.WriteLine("Usage: UploadMusic path_to_music music_name artist");
                return;
            }
            string musicToUpload = args[0];
            FileInfo file = new FileInfo(musicToUpload);
            String ext = file.Extension;
            if (ext != ".wav")
            {
                Console.WriteLine("Please upload a .wav file.");
                return;
            }
            Console.WriteLine(String.Format("Uploading {0}", musicToUpload));
            Console.WriteLine("Inserting to database...");
            var dbConnStr = CloudConfigurationManager.GetSetting("DbConnectionString");
            SqlConnection conn = new SqlConnection(dbConnStr);
            String insertCmdStr = "INSERT INTO music(music_name, artist, size) OUTPUT INSERTED.ID VALUES(@music_name, @artist, @size)";
            SqlCommand insertCmd = new SqlCommand(insertCmdStr, conn);
            insertCmd.Parameters.AddWithValue("@music_name", args[1]);
            insertCmd.Parameters.AddWithValue("@artist", args[2]);
            insertCmd.Parameters.AddWithValue("@size", file.Length);
            conn.Open();
            SqlDataReader reader = insertCmd.ExecuteReader();
            // Read the first record of music
            reader.Read();
            long musicId = reader.GetInt64(0);
            conn.Close();
            Console.WriteLine(String.Format("Inserting success, music id: {0}", musicId));

            string newFileName = String.Format("{0}.wav", musicId);
            Console.WriteLine(String.Format("Uploading file to storage...", musicId));

            string containerName = CloudConfigurationManager.GetSetting("containerName");

            // Retrieve storage account information from connection string
            CloudStorageAccount storageAccount = Common.CreateStorageAccountFromConnectionString();

            // Create a blob client for interacting with the blob service.
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            CloudBlobContainer container = blobClient.GetContainerReference(containerName);

            CloudBlockBlob blockBlob = container.GetBlockBlobReference(newFileName);
            try
            {
                blockBlob.UploadFromFile(musicToUpload);
            } catch (Exception e)
            {
                Console.WriteLine("Upload file failed, trying to delete the db record...");
                String deleteCmdStr = "DELETE FROM music WHERE id=@music_id";
                SqlCommand deleteCmd = new SqlCommand(deleteCmdStr, conn);
                deleteCmd.Parameters.AddWithValue("@music_id", musicId);
                conn.Open();
                try
                {
                    deleteCmd.ExecuteNonQuery();
                } catch (Exception)
                {
                    Console.WriteLine(String.Format("Delete record {0} in music table failed.", musicId));
                }
                conn.Close();
                return;
            }
            

            Console.WriteLine("Upload success");
            Console.WriteLine("Press any key to exit.");
            Console.ReadLine();
        }
    }
}
