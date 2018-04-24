// !preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)
//
// r2d3: https://rstudio.github.io/r2d3
//

var bars = r2d3.svg.selectAll('rect')
    .data(r2d3.data);
    
bars.enter()
    .append('rect')
      .attr('width', function(d) { return d * width; })
      .attr('height', '20px')
      .attr('y', function(d, i) { return i * 22; })
      .attr('fill', 'steelblue');

bars.exit().remove();

bars.transition()
  .duration(0)
  .attr("width", function(d) { return d * width; });