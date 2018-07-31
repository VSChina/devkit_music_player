namespace DemoBotApp
{
    using System.IO;
    using System.Web.Hosting;

    public class SampleMusic
    {
        private static MemoryStream audioStream = new MemoryStream();
        private static byte[] audioBytes;

        static SampleMusic()
        {
            audioStream = new MemoryStream();         
        }

        public static Stream GetStream(string sampleMusicFilePath)
        {
            // string sampleMusicFilePath = HostingEnvironment.MapPath(string.Format("~/{0}.wav", musicId));
            if (File.Exists(sampleMusicFilePath))
            {
                audioBytes = File.ReadAllBytes(sampleMusicFilePath);
            }
            MemoryStream ms = new MemoryStream();
            ms.Write(audioBytes, 0, audioBytes.Length);
            ms.Position = 0;
            return ms;
        }

        ~SampleMusic()
        {
            audioStream.Dispose();
        }
    }
}