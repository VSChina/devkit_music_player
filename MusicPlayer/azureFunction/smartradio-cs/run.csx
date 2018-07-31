#r "Newtonsoft.Json"
#r "System.Web"
#r "System.Configuration"
#r "System.Data"
#r "Microsoft.ServiceBus"

using System;
using System.Text;
using System.Configuration;
using System.Net;
using System.IO;
using System.Web;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Azure.Devices;
using Microsoft.ServiceBus.Messaging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

// Object used to decode reported JSON message from device
public class DeviceObject
{
    public string firstTime = null;
    public int music_id;
    public float play_progress;
}

//Retrieve device id from EventData Object
private static string GetDeviceId(EventData message)
{
    return message.SystemProperties["iothub-connection-device-id"].ToString();
}

public static void Run(EventData myEventHubMessage, TraceWriter log)
{
    try {
        var deviceId = GetDeviceId(myEventHubMessage);
        var json = System.Text.Encoding.UTF8.GetString(myEventHubMessage.GetBytes());
        DeviceObject deviceObject = Newtonsoft.Json.JsonConvert.DeserializeObject<DeviceObject>(json);
        log.Info($"C# Event Hub trigger function processed a message from {deviceId}: {json}");
        // If it is the first time that device report, we have to send back two songs info rather than one.
        int query_num = String.IsNullOrEmpty(deviceObject.firstTime) ? 1 : 2;
        string message = string.Empty;

        var dbConnStr = ConfigurationManager.ConnectionStrings["sqldb_connection"].ConnectionString;
        SqlConnection conn = new SqlConnection(dbConnStr);
        conn.Open();
        // Query database for song info, by random for now.
        String queryCmdStr = "SELECT TOP {0} * FROM music ORDER BY NEWID()";
        queryCmdStr = String.Format(queryCmdStr, query_num);

        SqlCommand insertCmd = null, queryCmd = new SqlCommand(queryCmdStr, conn);
        SqlDataReader reader = queryCmd.ExecuteReader();
        // Read the first record of music
        reader.Read();
        // Format JSON string to be send back to device with music info
        string musicJsonFormat = "{{\"music_id\":{0}, \"music_name\":\"{1}\", \"artist\": \"{2}\", \"size\":{3}}}";
        message = String.Format(musicJsonFormat, reader.GetInt64(0), reader.GetString(1), reader.GetString(2), reader.GetInt32(3));
        if (query_num == 2) {
            // Read the second music info.
            reader.Read();
            string nextMsg = String.Format(musicJsonFormat, reader.GetInt64(0), reader.GetString(1), reader.GetString(2), reader.GetInt32(3));
            // Format the JSON string.
            message = "{\"current\":" + message + ", \"next\":" + nextMsg + "}";
        } else {
            // Insert the play record get from device
            String insertCmdStr = "INSERT INTO play_record(device_id, music_id, play_time, play_progress) VALUES(@device_id, @music_id, @play_time, @play_progress)";
            insertCmd = new SqlCommand(insertCmdStr, conn);
            insertCmd.Parameters.AddWithValue("@device_id", deviceId);
            insertCmd.Parameters.AddWithValue("music_id", deviceObject.music_id);
            insertCmd.Parameters.AddWithValue("@play_time", DateTime.Now);
            insertCmd.Parameters.AddWithValue("@play_progress", deviceObject.play_progress);
            // Format the JSON string.
            message = "{\"next\":" + message + "}";
        }
        reader.Close();
        log.Info(message);
        // Send music info JSON to device
        string connectionString = ConfigurationManager.AppSettings["iotHubConnectionString"];
        using(ServiceClient serviceClient = ServiceClient.CreateFromConnectionString(connectionString))
        {
            Message commandMessage = new Message(Encoding.UTF8.GetBytes(message));
            serviceClient.SendAsync(deviceId, commandMessage).Wait();
        }
        // Save the play record to db.
        if (insertCmd != null) {
            insertCmd.ExecuteNonQuery();
            log.Info("Write to db");
        }
        conn.Close();
    } catch(Exception ex) {
        log.Error(ex.ToString());
        throw ex;
    }
    
}