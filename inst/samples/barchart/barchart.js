// data, div, width, height and options are provided by r2d3

var bars = root
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
