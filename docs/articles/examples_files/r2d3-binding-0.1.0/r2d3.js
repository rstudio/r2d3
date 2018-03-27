HTMLWidgets.widget({
  name: 'r2d3',
  type: 'output',
  factory: function(el, width, height) {

    var r2 = new R2(el);

    return {
      renderValue: function(x) {
        r2.data(x);
        r2.width(width);
        r2.height(height);
        
        d3Script(x.data, r2);
      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
