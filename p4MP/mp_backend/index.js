import express from "express";
import cors from "cors";
import { MercadoPagoConfig, Payment } from "mercadopago";

const client = new MercadoPagoConfig({ accessToken: "YOUR_ACESS_TOKEN" });

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Servidor levantado ");
});

app.listen(port, () => {
  console.log(`Escuchando el puerto ${port}`);
});
