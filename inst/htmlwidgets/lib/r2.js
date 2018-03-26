function R2(el) {
  var self = this;
  var x;
  
  self.el = el;
  self.root = "#" + el.id;
  
  self.data = function(newX) {
    x = newX;
  };
        
  self.d3 = function(update) {
    
    if (typeof(update) != "undefined") {
      update(x.data);
      
      if (typeof(Shiny) !== "undefined") {
        update(x.data);
        Shiny.addCustomMessageHandler("d3_update", function(x) {
          update(x.data);
        });
      }
    }
    
    return new Promise(function(resolve, reject) {
      resolve(x.data);
    });
  };
  
}