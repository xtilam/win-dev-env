import net from "net";
const serverPort = process.argv[2];
const client = net.createConnection({ port: serverPort });

client.on("connect", () => {
  client.write(JSON.stringify(process.env));
  client.end();
});
