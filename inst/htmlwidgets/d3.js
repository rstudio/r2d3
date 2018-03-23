var d3 = d3 ? d3 : {};

HTMLWidgets.widget({
  name: 'd3',
  type: 'output',
  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {
      renderValue: function(x) {
        d3.r = function(update) {
          
          if (typeof(update) != "undefined" && typeof(Shiny) !== "undefined") {
            Shiny.addCustomMessageHandler("d3_update", function(x) {
              update(x.data);
            });
          }
          
          return new Promise(function(resolve, reject) {
            resolve(x.data);
          });
        };
        d3_script();
      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
