// !preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)

var barHeight = Math.floor(r2d3.height / r2d3.data.length);
r2d3.svg.selectAll('rect')
    .data(r2d3.data)
  .enter()
    .append('rect')
      .attr('width', function(d) { return d * r2d3.width; })
      .attr('height', barHeight)
      .attr('y', function(d, i) { return i * barHeight; })
      .attr('fill', 'steelblue');
