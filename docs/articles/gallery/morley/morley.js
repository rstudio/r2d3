// !preview r2d3 data = read.csv("morley.csv"), d3_version = 3, container = "div", dependencies = c("box.js")

// Based on: https://bl.ocks.org/mbostock/4061502

var margin = {top: 10, right: 40, bottom: 20, left: 40},
    width = (width/4) - 10 - margin.left - margin.right,
    height = height - margin.top - margin.bottom;

var min = Infinity,
    max = -Infinity;

var chart = d3.box()
    .whiskers(iqr(1.5))
    .width(width)
    .height(height);

r2d3.onRender(function(csv, div, w, h, options) {
  var data = [];

  csv.forEach(function(x) {
    var e = Math.floor(x.Expt - 1),
        r = Math.floor(x.Run - 1),
        s = Math.floor(x.Speed),
        d = data[e];
    if (!d) d = data[e] = [s];
    else d.push(s);
    if (s > max) max = s;
    if (s < min) min = s;
  });

  chart.domain([min, max]);

  var svg = div.selectAll("svg")
    .data(data)
  .enter().append("svg")
    .attr("class", "box")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.bottom + margin.top)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .call(chart);
    
  svg.selectAll(".box line, .box rect, .box circle ")
    .attr("fill", theme.background)
    .attr("stroke", theme.foreground);

  setInterval(function() {
    svg.datum(randomize).call(chart.duration(1000));
  }, 2000);
});

function randomize(d) {
  if (!d.randomizer) d.randomizer = randomizer(d);
  return d.map(d.randomizer);
}

function randomizer(d) {
  var k = d3.max(d) * .02;
  return function(d) {
    return Math.max(min, Math.min(max, d + k * (Math.random() - .5)));
  };
}

// Returns a function to compute the interquartile range.
function iqr(k) {
  return function(d, i) {
    var q1 = d.quartiles[0],
        q3 = d.quartiles[2],
        iqr = (q3 - q1) * k,
        i = -1,
        j = d.length;
    while (d[++i] < q1 - iqr);
    while (d[--j] > q3 + iqr);
    return [i, j];
  };
}
