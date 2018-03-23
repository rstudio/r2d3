d3.r().then(function(data) {
  d3.select("body")
    .append("div")
      .selectAll("div")
        .data(data)
      .enter().append("div")
        .style("width", function(d) { return d * 10 + "px"; })
        .style("background-color", "#DDD")
        .text(function(d) { return d; });
});
