var barHeight = Math.floor(height / data.length);
svg.selectAll('rect')
    .data(data)
  .enter()
    .append('rect')
      .attr('width', function(d) { return d * width; })
      .attr('height', barHeight)
      .attr('y', function(d, i) { return i * barHeight; })
      .attr('fill', 'steelblue');
