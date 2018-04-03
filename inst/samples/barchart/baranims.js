var bars = svg.selectAll('rect')
    .data(data);
    
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
