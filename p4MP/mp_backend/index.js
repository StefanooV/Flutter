import express from "express";
import cors from "cors";

import { MercadoPagoConfig, Preference } from "mercadopago";

const client = new MercadoPagoConfig({
  accessToken:
    "APP_USR-5907347360071966-111408-e1ef09fff344e37cbe9e05c5b14dd5a6-827482907",
});

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Servidor levantado ");
});

app.post("/create_preference", async (req, res) => {
  try {
    const body = {
      items: [
        {
          // title: req.body.title,
          // quantity: Number(req.body.quantity),
          // unit_price: Number(req.body.unit_price),
          title: "Remera Ovesize",
          quantity: 2,
          unit_price: 54000,
          currency_id: "ARS",
        },
      ],
      back_urls: {
        success: "https://httpstat.us/200",
        failure: "https://httpstat.us/400",
        pending: "https://httpstat.us/202",
      },
      auto_return: "approved",
    };
    const preference = new Preference(client);
    const result = await preference.create({ body });
    console.log(result);
    res.json({
      url: result.sandbox_init_point,
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({
      err: "Error al crear la preferencia :(",
    });
  }
});

app.listen(port, () => {
  console.log(`Escuchando el puerto ${port}`);
});
