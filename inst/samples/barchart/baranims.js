var bars = r2d3.svg.selectAll('rect')
    .data(r2d3.data);
    
bars.enter()
    .append('rect')
      .attr('width', function(d) { return d * 10; })
      .attr('height', '20px')
      .attr('y', function(d, i) { return i * 22; })
      .attr('fill', 'steelblue');

bars.exit().remove();

bars.transition()
  .duration(250)
  .attr("width", function(d) { return d * 10; });
