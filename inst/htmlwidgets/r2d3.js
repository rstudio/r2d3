HTMLWidgets.widget({
  name: 'r2d3',
  type: 'output',
  factory: function(el, width, height) {

    var r2d3 = new R2D3(el, width, height);

    return {
      renderValue: function(x) {
        r2d3.widgetRender(x);
      },

      resize: function(width, height) {
        r2d3.widgetResize(width, height);
      }
    };
  }
});
