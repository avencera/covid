import css from "../css/app.css";
import React from "react";
import ReactDOM from "react-dom";

import "phoenix_html";

import Chart from "./chart";

const chartElements = Array.from(document.getElementsByClassName("chart"));

chartElements.forEach(element => {
  let data = JSON.parse(element.dataset["cases"]);
  ReactDOM.render(<Chart data={data}></Chart>, element);
});
