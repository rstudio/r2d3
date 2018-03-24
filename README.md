D3 rendering for R
================

Install this package by running:

``` r
devtools::install_github("rstudio/d3")
```

Lets start with a static D3 script:

    var data = [4, 8, 15, 16, 23, 42];

    d3.select("body")
      .append("div")
        .selectAll("div")
          .data(data)
        .enter().append("div")
          .style("width", function(d) { return d * 10 + "px"; })
          .style("background-color", "steelblue")
          .style("border", "1px solid white")
          .style("color", "white")
          .style("padding-left", "2px")
          .text(function(d) { return d; });

This can be rendered using:

``` r
library(d3)
d3_render(script = system.file("samples/barchart-static.js", package = "d3"))
```

![](tools/README/d3-static.png)

While this is helpful, data is usually not static, in `D3`, one can download JSON data using:

    d3.json("https://s3.amazonaws.com/javierluraschi/d3/barchart-json.json").then(function(data) {
      d3.select("body")
        .append("div")
          .selectAll("div")
            .data(data)
          .enter().append("div")
            .style("width", function(d) { return d * 10 + "px"; })
            .style("background-color", "steelblue")
            .style("border", "1px solid white")
            .style("color", "white")
            .style("padding-left", "2px")
            .text(function(d) { return d; });
    });

This file can be rendered as well by the same command for this file:

``` r
d3_render(script = system.file("samples/barchart-json.js", package = "d3"))
```

![](tools/README/d3-static.png)

Now, what is more helpful for R users is to provide this data from R, this can be done by using `d3.r()` instead of `d3.json()` as follows:

    d3.r().then(function(data) {
      d3.select("body")
        .append("div")
          .selectAll("div")
            .data(data)
          .enter().append("div")
            .style("width", function(d) { return d * 10 + "px"; })
            .style("background-color", "steelblue")
            .style("border", "1px solid white")
            .style("color", "white")
            .style("padding-left", "2px")
            .text(function(d) { return d; });
    });

``` r
d3_render(
  data = c(10, 30, 40, 35, 20, 10),
  script = system.file("samples/barchart-variable.js", package = "d3"))
```

![](tools/README/d3-variable.png)

Finally, instead of providing static data, one can provide a function that provides data. Since `d3.json()` an `d3.r()` expect promises and for animations we rather need to update data continuosly, we will pass a function to `d3.r()` as follows:

    d3.r(function(data) {
      var bars = d3.select("#d3")
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

To render an animation, we will use `d3_animate()` instead and provide a function that provide data instead of data on it's own:

``` r
d3_animate(
  function() floor(runif(6, 1, 40)),
  system.file("samples/barchart-animate.js", package = "d3")
)
```

![](tools/README/d3-animate.gif)
