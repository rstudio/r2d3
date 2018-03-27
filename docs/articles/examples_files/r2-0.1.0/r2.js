function R2(el) {
  var self = this;
  var x;
  
  self.el = el;
  self.root = "#" + el.id;
  self.width = 0;
  self.height = 0;
  
  var doUpdate = function(f, data) {
    // handle optional error parameter in callbacks
    if (f.length == 2)
      f(null, data);
    else
      f(data);
  };
  
  self.data = function(newX) {
    x = newX;
  };
  
  self.width = function(width) {
    self.width = width;
  };
  
  self.height = function(height) {
    self.height = height;
  };
  
  self.d3 = function(arg1, arg2) {
    
    // assign parameters dynamically since d3 supports d3.csv([row,] update)
    var params = {};
    if (typeof(arg1) !== "undefined") params = { update: arg1 };
    if (typeof(arg2) !== "undefined") params = { row: arg1, update: arg2};
    
    if (x.type == "data.frame") {
      x.data = HTMLWidgets.dataframeToD3(x.data);
    }
    
    if (typeof(params.row) === "function") {
      var dataNew = [];
      for (var idx = 0; idx < x.data.length; idx++) {
        var rowNew = params.row(x.data[idx]);
        if (rowNew) dataNew.push(rowNew);
      }
      x.data = dataNew;
    }
    
    if (typeof(params.update) != "undefined") {
      doUpdate(params.update, x.data);
      
      if (typeof(Shiny) !== "undefined") {
        doUpdate(params.update, x.data);
        Shiny.addCustomMessageHandler("d3_update", function(x) {
          doUpdate(params.update, x.data);
        });
      }
    }
    
    
    return new Promise(function(resolve, reject) {
      resolve(x.data);
    });
  };
        
  /*
  self.d3 = function(update) {
    self.d3(null, update);
  };
  */
  
}