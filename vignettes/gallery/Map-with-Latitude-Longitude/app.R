library()
a<- jsonlite::read_json("test.json")
r2d3(data = jsonlite::read_json("test.json"),css = "map.css", d3_version = 3, dependencies = c("topojson.min.js", "http://labratrevenge.com/d3-tip/javascripts/d3.tip.v0.6.3.js"), script = "map.js")
