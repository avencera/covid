import React from "react";
import {
  Scatter,
  XAxis,
  Legend,
  YAxis,
  ResponsiveContainer,
  Line,
  CartesianGrid,
  Tooltip,
  ComposedChart
} from "recharts";

const mergeCasesAndPredictions = (cases, predictions, country) => {
  return { [country]: cases[country].concat(predictions[country]) };
};

const Chart = ({ cases, predictions, countries_with_colors, dates }) => {
  const countries = Object.keys(cases);

  const data =
    countries.length == 1 && predictions
      ? countries
          .map(country => mergeCasesAndPredictions(cases, predictions, country))
          .reduce((acc, current) => {
            return { ...acc, ...current };
          }, {})
      : cases;

  return (
    <ResponsiveContainer width={"99%"} height={500}>
      <ComposedChart margin={{ top: 20, bottom: 20, right: 60, left: 60 }}>
        <CartesianGrid stroke="#f5f5f5" />
        <XAxis type="number" dataKey="day" name="days" unit=" days" />
        <YAxis
          type="number"
          unit=" cases"
          domain={[0, "dataMax"]}
          tickFormatter={tick => {
            return Math.floor(tick).toLocaleString();
          }}
        />
        <Tooltip
          cursor={{ strokeDasharray: "3 3" }}
          labelFormatter={day => `Days: ${day} (${dates[day]})`}
          formatter={(value, _name, _props) => {
            return Math.floor(value).toLocaleString();
          }}
        />

        {countries.map(country => (
          <Scatter
            name={country}
            dataKey="cases"
            name={countries.length == 1 ? `Cases` : country}
            data={data[country]}
            key={country}
            fill={`#${countries_with_colors[country].cases}`}
          />
        ))}

        {countries.map(country => (
          <Line
            key={`${country}-line`}
            dataKey="predicted_cases"
            data={data[country]}
            strokeDasharray="5 5"
            stroke={`#${countries_with_colors[country].predictions}`}
            name={`Predicted Cases`}
            dot={false}
            activeDot={false}
            legendType="none"
          />
        ))}

        {countries.length == 1 ? <div></div> : <Legend></Legend>}
      </ComposedChart>
    </ResponsiveContainer>
  );
};

export default Chart;
