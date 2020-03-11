import css from "../css/app.css";
import React from "react";
import ReactDOM from "react-dom";

import "phoenix_html";

import Chart from "./chart";

const chartElement = document.getElementById("chart");
if (chartElement && chartElement.dataset["cases"]) {
  const data = JSON.parse(chartElement.dataset["cases"]);

  ReactDOM.render(<Chart data={data}></Chart>, chartElement);
}
