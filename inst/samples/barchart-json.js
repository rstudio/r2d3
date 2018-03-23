d3.json("https://s3.amazonaws.com/javierluraschi/d3/barchart-json.json").then(function(data) {
  d3.select("body")
    .append("div")
      .selectAll("div")
        .data(data)
      .enter().append("div")
        .style("width", function(d) { return d * 10 + "px"; })
        .style("background-color", "#DDD")
        .text(function(d) { return d; });
});
