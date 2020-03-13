import css from "../css/app.css";

import "phoenix_html";
import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";
import LiveReact from "phoenix_live_react";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

const hooks = { LiveReact };

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: hooks,
  params: { _csrf_token: csrfToken }
});

liveSocket.connect();

import Chart from "./chart";
window.Components = {
  Chart
};
