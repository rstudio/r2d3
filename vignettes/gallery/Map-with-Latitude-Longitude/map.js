
var places = [
              {
                name: "1 Gorkha Rifles",
				nam: "https://en.wikipedia.org/wiki/1_Gorkha_Rifles",
                location: {
                  latitude: 30.975441,
                  longitude: 76.990228
                }
              },
              {
                name: "3 Gorkha Rifles",
				nam: "https://en.wikipedia.org/wiki/3_Gorkha_Rifles",
                location: {
                  latitude: 25.317645,
                  longitude:82.973914
                }
              }
			  ,
              {
                name: "5 Gorkha Rifles",
                nam: "https://en.wikipedia.org/wiki/5_Gorkha_Rifles",
				location: {
                  latitude: 25.578773,
                  longitude:91.893254
                }
              }
			  ,
              {
                name: "11 Gorkha Rifles",
                nam: "https://en.wikipedia.org/wiki/11_Gorkha_Rifles",
				location: {
                  latitude: 26.846694,
                  longitude: 80.946166
                }
              }
			  ,
              {
                name: "Gharwal Rifles",
                nam: "https://en.wikipedia.org/wiki/Gharwal_Rifles",
				location: {
                  latitude: 29.837746,
                  longitude: 78.687107
                }
              }
			  ,
              {
                name: "Brigade of the Guards",
                nam: "https://en.wikipedia.org/wiki/Brigade_of_the_Guards",
				location: {
                  latitude: 21.227531,
                  longitude: 79.190083
                }
              }
			  ,
              {
                name: "Bihar Regiment",
				nam: "https://en.wikipedia.org/wiki/Bihar_Regiment",
                location: {
                  latitude: 25.620667,
                  longitude: 85.049325
                }
              }
			  ,
              {
                name: "Parachute Regiment",
                nam: "https://en.wikipedia.org/wiki/Parachute_Regiment",
				location: {
                  latitude: 12.971599,
                  longitude: 77.594563
                }
              }
			  ,
              {
                name: "Ramgarh Cantonment",
                nam: "https://en.wikipedia.org/wiki/Ramgarh_Cantonment",
				location: {
                  latitude:23.633224,
                  longitude: 85.514874
                }
              }
			  ,
              {
                name: "Madras Regiment",
                nam: "https://en.wikipedia.org/wiki/Madras_Regiment",
				location: {
                  latitude: 11.363560,
                  longitude: 76.788471
                }
              }
			  ,
              {
                name: "Grenadiers Regiment",
                nam: "https://en.wikipedia.org/wiki/Grenadiers_Regiment",
				location: {
                  latitude: 23.181467,
                  longitude: 79.986407
                }
              }
			  ,
              {
                name: "Maratha Light Infantry",
                nam: "https://en.wikipedia.org/wiki/Maratha_Light_Infantry",
				location: {
                  latitude: 15.849695,
                  longitude: 74.497674
                }
              },
              {
                name: "Rajputana Rifles",
                nam: "https://en.wikipedia.org/wiki/Rajputana_Rifles",
				location: {
                  latitude: 28.596128,
                  longitude: 77.158738
                }
              },
              {
                name: "Kumaon Regiment",
                nam: "https://en.wikipedia.org/wiki/Kumaon_Regiment",
				location: {
                  latitude: 29.643362,
                  longitude: 79.432182
                }
              }
			  ,
              {
                name: "Sikh Light Infantry",
                nam: "https://en.wikipedia.org/wiki/Sikh_Light_Infantry",
				location: {
                  latitude: 27.367290,
                  longitude: 79.622137
                }
              }
            ];
var width = 960,
    height = 600;
var color= d3.scale.ordinal()
			.domain([1,2,3,4,5,6,7,8,9])
			.range("red", "steelblue");

var projection = d3.geo.mercator().scale(1100).translate([-1000,800]);
var path = d3.geo.path()
    .projection(projection);

var root = svg 
    .attr("viewBox", "0 0 900 800")
	 .attr("preserveAspectRatio", "xMidYMid meet");
var data;
r2d3.onRender(function(us, svg, width, height, options) {


  var cantons = topojson.feature(us, us.objects.india);
  
  			//svg.call(tip);
			var group=root.selectAll("g")
				.data(cantons.features)
				.enter()
				.append("g");
				//.on('mouseover', tip.show)
      			//.on('mouseout', tip.hide)
					
					
					var tip = d3.tip()
							.attr('class', 'd3-tip')
							.offset([-5, 0])
							.style("left", "300px")
							.style("top", "400px")
							.html(function(d) {
								return ("<a href="+d.nam+" target='_blank'>"+d.name +"</a>");
							});
							
						root.call(tip);


root.selectAll(".pin")
						  .data(places)
						  .enter().append("circle", ".pin")
						  .attr("r", 5)
						  .attr("transform", function(d) {
							return "translate(" + projection([
							  d.location.longitude,
							  d.location.latitude
							]) + ")";
						  })
						  .on('mouseover', tip.show)
							.on('click', tip.hide);		
					
				//var projection = d3.geo.mercator().scale(900).translate([-600,700]);
				var path= d3.geo.path().projection(projection);

				var areas= group.append("path")
					.attr("d", path)
					.attr("class", "area")
				 .attr("fill","steelblue");
						
});