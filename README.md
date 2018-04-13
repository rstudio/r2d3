r2d3: R interface to D3 visualizations
================

<!---
TODO:
  - Add gallery thumbnails at the bottom of first section
  - Cleanup language at the bottom of the first section
--->

<img src="images/r2d3-hex.png" width=180 align="right" style="border: none; margin-right: 10px;"/>

The **r2d3** package provides a suite of tools for using [D3
visualizations](https://d3js.org/) with R, including:

  - Translating R data frames into D3 friendly data structures

  - Rendering D3 scripts within the [RStudio
    Viewer](https://support.rstudio.com/hc/en-us/articles/202133558-Extending-RStudio-with-the-Viewer-Pane)
    and [R Notebooks](https://rmarkdown.rstudio.com/r_notebooks.html)

  - Incorporating D3 scripts into [R
    Markdown](https://rmarkdown.rstudio.com/) reports, presentations,
    and dashboards

  - Creating interacive D3 applcations with
    [Shiny](https://shiny.rstudio.com/)

  - Publishing D3 based [htmlwidgets](http://www.htmlwidgets.org) in R
    packages

With **r2d3**, you can bind data from R to D3 visualizations like the
ones found on the [D3 Gallery](https://github.com/d3/d3/wiki/Gallery),
[Blocks](https://bl.ocks.org/), or [VIDA](https://vida.io/explore). D3
visualizations you create work just like R plots within RStudio, R
Markdown documents, and Shiny applications.

## Getting Started

First, install the package from GitHub as follows:

``` r
devtools::install_github("rstudio/r2d3")
```

Next, install the [daily build](https://dailies.rstudio.com) of RStudio
(you need this version of RStudio to take advantage of various
integrated tools for authoring D3 scripts with
r2d3):

<a href="https://dailies.rstudio.com"><img src="images/daily_build.png" class="screenshot" width=600/></a>

## D3 Scripts

To use **r2d3**, write a D3 script and then pass R data to it using the
`rd23()` function. For example, here’s a simple D3 script that draws a
bar chart (“barchart.js”):

``` js
var barHeight = Math.floor(height / data.length);

svg.selectAll('rect')
  .data(data)
  .enter().append('rect')
    .attr('width', function(d) { return d * width; })
    .attr('height', barHeight)
    .attr('y', function(d, i) { return i * barHeight; })
    .attr('fill', 'steelblue');
```

To render the script within R you call the `r2d3()` function:

``` r
library(r2d3)
r2d3(data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20), script = "barchart.js")
```

Which results in the following visualization:

<img src="images/bar_chart.png" class="illustration" width=600/>

Note that data is provided to the script using the `data` argument to
the `r2d3()` function. This data is then automatically made available to
the D3 script. There are a number of other special variables available
within D3 scripts, including:

  - `data` — The R data converted to JavaScript.
  - `svg` — The svg container for the visualization
  - `width` — The current width of the container
  - `height` — The current height of the container
  - `options` — Additional options provided by the user

## D3 Preview

The [daily build](https://dailies.rstudio.com) of RStudio includes
support for previewing D3 scripts as you write them. To try this out,
create a D3 script using the new file menu:

<img src="images/new_d3_script.png" class="screenshot" width=600/>

A simple template for a D3 script (the barchart.js example shown above)
is provided by default. You can use the **Preview** command
(Ctrl+Shift+Center) to render the visualization:

<img src="images/rstudio_preview.png" class="screenshot" width=600/>

You might wonder where the data comes from for the preview. Note that
there is a special comment at the top of the D3 script:

``` js
// !preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)
```

This comment enables you to specify the data (along with any other
arguments to the `r2d3()` function) to use for the preview.

## R Markdown

You can include D3 visualizations in an R Markdown document or R
Notebook. You can do this by calling the `r2d3()` function from within
an R code chunk:

<pre><code>---
output: html_document
---

&#96``{r}
library(r2d3)
r2d3(data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20), script = "barchart.js")
&#96``</code></pre>

![](images/bar_chart.png)

You can also include D3 visualization code inline using the `d3` chunk
type:

<pre><code>&#96``{r setup}
library(r2d3)
bars &lt;- c(10, 20, 30)
&#96``</code></pre>

<pre><code>&#96``{d3 data=bars, options=list(color = 'orange')}
svg.selectAll('rect')
  .data(data)
  .enter()
    .append('rect')
      .attr('width', function(d) { return d * 10; })
      .attr('height', '20px')
      .attr('y', function(d, i) { return i * 22; })
      .attr('fill', options.color);
&#96``</code></pre>

<img src="images/rmarkdown-1.png" class="illustration"/>

## Shiny

The `renderD3()` and `d3Output()` functions enable you to include D3
visualizations within Shiny applications:

``` r
library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    sliderInput("bar_max", label = "Max:",
      min = 10, max = 110, value = 10, step = 20)
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output$d3 <- renderD3({
    r2d3(
      floor(runif(5, 5, input$bar_max)),
      system.file("baranims.js", package = "r2d3")
    )
  })
}

shinyApp(ui = ui, server = server)
```

<img src="images/baranim-1.gif" class="illustration" width=600/>

## Learning More

  - [Gallery of
    Examples](https://rstudio.github.io/r2d3/articles/gallery.html) —
    Learn from a wide variety of example D3 visualizations.

  - [R to D3 Data
    Conversion](https://rstudio.github.io/r2d3/articles/data_conversion.html)
    — Customize the conversion of R objects to D3-friendly JSON.

  - [Visualization
    Options](https://rstudio.github.io/r2d3/articles/visualization_options.html)
    — Control various aspects of D3 rendering and expose user-level
    options for your D3 script.

  - [Development and
    Debugging](https://rstudio.github.io/r2d3/articles/development_and_debugging.html)
    — Recommended tools and workflow for developing D3 visualizations.

  - [CSS and JavaScript
    Dependencies](https://rstudio.github.io/r2d3/articles/dependencies.html)
    — Incorporating external CSS styles and JavaScript libraries into
    your visualizations.

  - [Advanced Rendering with
    Callbacks](https://rstudio.github.io/r2d3/articles/advanced_rendering.html)
    — An alternate way to organize D3 scripts that enables you to
    distinguish between initialization and re-rendering based on new
    data, as well as handle resizing more dynamically.

  - [Package
    Development](https://rstudio.github.io/r2d3/articles/package_development.html)
    – Create re-usable D3 visualizations by including them in an R
    package.
