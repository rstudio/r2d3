HTMLWidgets.widget({
  name: 'r2d3',
  type: 'output',
  factory: function(el, width, height) {

    var r2d3 = new R2D3();

    return {
      renderValue: function(x) {
        if (!r2d3.root) {
          r2d3.setVersion(x.version);
          r2d3.addScript(x.script);
          r2d3.addStyle(x.style);
          
          var root = r2d3.d3().select(el).append(x.tag)
            .attr("width", width)
            .attr("height", height);
            
          r2d3.setRoot(root);
        }
        
        r2d3.setX(x);
        r2d3.setWidth(width);
        r2d3.setHeight(height);
        
        d3Script(r2d3.d3(), r2d3, x.data, r2d3.root, width, height, x.options);
      },

      resize: function(width, height) {
        r2d3.root
          .attr("width", width)
          .attr("height", height);
        
        // TODO: If has resize then resize otherwise d3Script_hash()
        r2d3.resize(width, height);
      }
    };
  }
});
