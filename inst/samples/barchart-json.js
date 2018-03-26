d3.json("https://s3.amazonaws.com/javierluraschi/d3/barchart-json.json", function(data) {
  var bars = d3.select("body")
    .selectAll("div")
      .data(data);
      
  bars.enter().append("div")
    .style("width", function(d) { return 4 + d * 10 + "px"; })
    .style("background-color", "steelblue")
    .style("border", "1px solid white")
    .style("color", "white")
    .style("padding-left", "2px")
    .text(function(d) { return d; });
  
  bars.exit().remove();
  
  bars.transition()
    .duration(250)
    .style("width", function(d) { return 4 + d * 10 + "px"; })
    .text(function(d) { return d; });
});
