r2.d3(function(data) {
  var bars = d3.select(r2.root)
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
