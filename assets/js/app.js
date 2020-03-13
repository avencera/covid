import css from "../css/app.css";
import React from "react";
import ReactDOM from "react-dom";

import "phoenix_html";

import Chart from "./chart";

const chartElements = Array.from(document.getElementsByClassName("chart"));

chartElements.forEach(element => {
  const cases = JSON.parse(element.dataset["cases"]);

  const predictions =
    element.dataset["predictions"] &&
    JSON.parse(element.dataset["predictions"]);

  ReactDOM.render(
    <Chart cases={cases} predictions={predictions}></Chart>,
    element
  );
});
