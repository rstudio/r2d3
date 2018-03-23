var data = [4, 8, 15, 16, 23, 42];

d3.select("body")
  .append("div")
    .selectAll("div")
      .data(data)
    .enter().append("div")
      .style("width", function(d) { return d * 10 + "px"; })
      .style("background-color", "#DDD")
      .text(function(d) { return d; });
