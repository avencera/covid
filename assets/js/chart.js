import React from "react";
import {
  ScatterChart,
  Scatter,
  XAxis,
  Legend,
  YAxis,
  ResponsiveContainer,
  ZAxis,
  CartesianGrid,
  Tooltip
} from "recharts";

const Chart = ({ data }) => {
  const countries = Object.keys(data);

  return (
    <ResponsiveContainer width={"99%"} height={500}>
      <ScatterChart margin={{ top: 20, bottom: 20, right: 20, left: 20 }}>
        <CartesianGrid />
        <XAxis type="number" dataKey="x" name="days" unit=" days" />
        <YAxis type="number" dataKey="y" name="cases" unit=" cases" />
        <ZAxis type="category" dataKey="date" name="date" unit="" />
        <Tooltip cursor={{ strokeDasharray: "3 3" }} />
        <Legend></Legend>

        {countries.map(country => (
          <Scatter
            name={country}
            data={data[country]}
            key={country}
            fill={`#${data[country][0].color}`}
          />
        ))}
      </ScatterChart>
    </ResponsiveContainer>
  );
};

export default Chart;
