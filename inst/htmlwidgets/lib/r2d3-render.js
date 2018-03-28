function R2D3() {
  var self = this;
  var x = null;
  
  self.data = null;
  self.root = null;
  self.width = 0;
  self.height = 0;
  self.options = null;
  self.resizer = function(width, height) {};
  
  self.setX = function(newX) {
    x = newX;
    self.data = x.data;
    self.options = x.options;
  };
  
  self.setRoot = function(root) {
    self.root = root;
  };
  
  self.setWidth = function(width) {
    self.width = width;
  };
  
  self.setHeight = function(height) {
    self.height = height;
  };
  
  self.onRender = function(renderer) {

    if (x.type == "data.frame") {
      self.data = HTMLWidgets.dataframeToD3(self.data);
    }
    
    renderer(self.data, self.root, self.width, self.height, self.options);
    
  };
  
  self.onResize = function(resizer) {
    self.resizer = resizer;
  };
  
  self.resize = function(width, height) {
    self.width = width;
    self.height = height;
    self.resizer(width, height);
  };
  
}