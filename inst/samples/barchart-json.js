d3.json("https://s3.amazonaws.com/javierluraschi/d3/barchart-json.json").then(function(data) {
  d3.select("body")
    .append("div")
      .selectAll("div")
        .data(data)
      .enter().append("div")
        .style("width", function(d) { return d * 10 + "px"; })
        .style("background-color", "steelblue")
        .style("border", "1px solid white")
        .style("color", "white")
        .style("padding-left", "2px")
        .text(function(d) { return d; });
});
