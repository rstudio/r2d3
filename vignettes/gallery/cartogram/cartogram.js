// !preview r2d3 data = jsonlite::read_json("us.json"), d3_version = 3, dependencies = "topojson.min.js"

// Based on https://bl.ocks.org/mbostock/4055908

// Ratio of Obese (BMI >= 30) in U.S. Adults, CDC 2008
var valueById = [
   NaN, .187, .198,  NaN, .133, .175, .151,  NaN, .100, .125,
  .171,  NaN, .172, .133,  NaN, .108, .142, .167, .201, .175,
  .159, .169, .177, .141, .163, .117, .182, .153, .195, .189,
  .134, .163, .133, .151, .145, .130, .139, .169, .164, .175,
  .135, .152, .169,  NaN, .132, .167, .139, .184, .159, .140,
  .146, .157,  NaN, .139, .183, .160, .143
];

var path = d3.geo.path();

var root = svg
  .attr("width", "100%")
		.append("g");

r2d3.onRender(function(us, svg, width, height, options) {
  root.attr("transform", "scale(" + width / 900 + ")");
	    
  root.append("path")
      .datum(topojson.feature(us, us.objects.land))
      .attr("class", "land")
      .attr("d", path);

  root.selectAll(".state")
      .data(topojson.feature(us, us.objects.states).features)
    .enter().append("path")
      .attr("class", "state")
      .attr("d", path)
      .attr("transform", function(d) {
        var centroid = path.centroid(d),
            x = centroid[0],
            y = centroid[1];
        return "translate(" + x + "," + y + ")"
            + "scale(" + Math.sqrt(valueById[d.id] * 5 || 0) + ")"
            + "translate(" + -x + "," + -y + ")";
      })
      .style("stroke-width", function(d) {
        return 1 / Math.sqrt(valueById[d.id] * 5 || 1);
      });
});
