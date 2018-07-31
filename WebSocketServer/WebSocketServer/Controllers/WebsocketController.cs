namespace DemoBotApp.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;
    using System.Web;
    using System.Web.Http;
    using System.Diagnostics;
    using DemoBotApp.WebSocket;
    using Microsoft.Bing.Speech;
    using Microsoft.Bot.Connector.DirectLine;
    using NAudio.Wave;
    using Microsoft.WindowsAzure;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Auth;
    using Microsoft.WindowsAzure.Storage.Blob;
    using Microsoft.WindowsAzure.Storage.File;
    using Microsoft.WindowsAzure.Storage.RetryPolicies;


    [RoutePrefix("chat")]
    public class WebsocketController : ApiController
    {
        private readonly CancellationTokenSource cts = new CancellationTokenSource();

        private DirectLineClient directLineClient;
        private static readonly string DirectLineSecret = ConfigurationManager.AppSettings["DirectLineSecret"];
        private static readonly string BotId = ConfigurationManager.AppSettings["BotId"];

        private WebSocketHandler defaultHandler = new WebSocketHandler();
        private static Dictionary<string, WebSocketHandler> handlers = new Dictionary<string, WebSocketHandler>();

        //CloudStorageAccount storageAccount = CreateStorageAccountFromConnectionString(ConfigurationManager.AppSettings["StorageConnectionString"]);

        static string storageAccountName = ConfigurationManager.AppSettings["StorageAccount"];

        static string storageKey = ConfigurationManager.AppSettings["StorageKey"];

        StorageCredentials storageCredentials = new StorageCredentials(storageAccountName, storageKey);

        string baseURL = ConfigurationManager.AppSettings["StorageBaseUrl"];


        public WebsocketController()
        {
            // Setup bot client
            this.directLineClient = new DirectLineClient(DirectLineSecret);
        }

        [Route]
        [HttpGet]
        public async Task<HttpResponseMessage> Connect(string nickName)
        {
            if (string.IsNullOrEmpty(nickName))
            {
                throw new HttpResponseException(HttpStatusCode.BadRequest);
            }

            WebSocketHandler webSocketHandler = new WebSocketHandler();

            // Handle the case where client forgot to close connection last time
            if (handlers.ContainsKey(nickName))
            {
                WebSocketHandler origHandler = handlers[nickName];
                handlers.Remove(nickName);

                try
                {
                    await origHandler.Close();
                }
                catch
                {
                    // unexcepted error when trying to close the previous websocket
                }
            }

            handlers[nickName] = webSocketHandler;

            string conversationId = string.Empty;
            string watermark = null;

            webSocketHandler.OnOpened += ((sender, arg) =>
            {
                Conversation conversation = this.directLineClient.Conversations.StartConversation();
                conversationId = conversation.ConversationId;
            });

            webSocketHandler.OnTextMessageReceived += (async (sender, message) =>
            {
                // Do nothing with heartbeat message
                // Send text message to bot service for non-heartbeat message
                if (!string.Equals(message, "heartbeat", StringComparison.OrdinalIgnoreCase))
                {
                    await OnTextMessageReceived(webSocketHandler, message, conversationId, watermark);
                }
            });

            webSocketHandler.OnBinaryMessageReceived += (async (sender, bytes) =>
            {
                await OnBinaryMessageReceived(webSocketHandler, bytes, conversationId, watermark);
            });

            webSocketHandler.OnClosed += (sender, arg) =>
            {
                handlers.Remove(nickName);
            };

            HttpContext.Current.AcceptWebSocketRequest(webSocketHandler);
            return Request.CreateResponse(HttpStatusCode.SwitchingProtocols);
        }

        private async Task OnTextMessageReceived(WebSocketHandler handler, string message, string conversationId, string watermark)
        {
            await handler.SendMessage($"You said: {message}");
        }

        private async Task OnBinaryMessageReceived(WebSocketHandler handler, byte[] bytes, string conversationId, string watermark)
        {
            int musicId = BitConverter.ToInt32(bytes, 0);
            int startIdx = BitConverter.ToInt32(bytes, sizeof(int));
            Trace.TraceInformation(String.Format("get id {0}", musicId));
            Trace.TraceInformation(String.Format("start from {0}", startIdx));
            
            Uri uri = new Uri(baseURL + String.Format("{0}.wav", musicId));
            CloudFile file = new CloudFile(uri, storageCredentials);
            Trace.TraceInformation(uri.AbsoluteUri);
            byte[] totalBytes = new byte[file.Properties.Length];
            try
            {
                using (AutoResetEvent waitHandle = new AutoResetEvent(false))
                {
                    ICancellableAsyncResult result = file.BeginDownloadRangeToByteArray(totalBytes, 0, null, null, ar => waitHandle.Set(), null);
                    waitHandle.WaitOne();
                }
            } catch(Exception ex)
            {
                Trace.TraceError(ex.ToString());
            }
            
            Trace.TraceInformation(String.Format("File length {0}", totalBytes.Length));
            totalBytes = totalBytes.Skip(startIdx).ToArray();
            await handler.SendBinary(totalBytes, cts.Token);
        }
 
    }
}
