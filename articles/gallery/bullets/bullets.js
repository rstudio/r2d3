// !preview r2d3 data = jsonlite::read_json("bullets.json"), d3_version = 3, container = "div", dependencies = c("d3_bullet.js")

// Based on https://bl.ocks.org/mbostock/4061961

var margin = {top: 10, right: 40, bottom: 40, left: 130};
var width = width - margin.left - margin.right;
var height = Math.floor(height / data.length) - margin.top - margin.bottom;

div.attr("class", "bullets");

var chart = d3.bullet(margin.bottom)
  .width(width)
  .height(height);
  
var svg = div.selectAll("svg")
    .data(data)
  .enter().append("svg")
    .attr("class", "bullet")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .call(chart);

var title = svg.append("g")
    .style("text-anchor", "end")
    .attr("transform", "translate(-6," + height / 2 + ")");

title.append("text")
    .attr("class", "title")
    .text(function(d) { return d.title; });

title.append("text")
    .attr("class", "subtitle")
    .attr("dy", "1em")
    .text(function(d) { return d.subtitle; });

d3.selectAll("button").on("click", function() {
  svg.datum(randomize).call(chart.duration(1000)); // TODO automatic transition
});

function randomize(d) {
  if (!d.randomizer) d.randomizer = randomizer(d);
  d.ranges = d.ranges.map(d.randomizer);
  d.markers = d.markers.map(d.randomizer);
  d.measures = d.measures.map(d.randomizer);
  return d;
}

function randomizer(d) {
  var k = d3.max(d.ranges) * .2;
  return function(d) {
    return Math.max(0, d + k * (Math.random() - .5));
  };
}
