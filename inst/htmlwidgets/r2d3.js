HTMLWidgets.widget({
  name: 'r2d3',
  type: 'output',
  factory: function(el, width, height) {

    var r2d3 = new R2D3(el);

    return {
      renderValue: function(x) {
        r2d3.setX(x);
        r2d3.setWidth(width);
        r2d3.setHeight(height);
        
        if (!r2d3.root) {
          r2d3.setVersion(x.version);
          r2d3.addScript(x.script);
          r2d3.addStyle(x.style);
          r2d3.setContainer(x.container);
          
          r2d3.createRoot();
          
          d3Script(r2d3.d3(), r2d3);
        }
        
        r2d3.render();
        
        if (r2d3.renderer === null) {
          r2d3.onRender(function() {
            d3Script(r2d3.d3(), r2d3);
          });
        }
        
        if (r2d3.resizer === null) {
          r2d3.resizer = function() {
            r2d3.createRoot();
            d3Script(r2d3.d3(), r2d3);
            r2d3.render();
          };
        }
      },

      resize: function(width, height) {
        r2d3.root
          .attr("width", width)
          .attr("height", height);

        r2d3.setWidth(width);
        r2d3.setHeight(height);
        r2d3.resize();
      }
    };
  }
});
