function R2D3() {
  var self = this;
  var x = null;
  var version = null;
  
  self.data = null;
  self.root = self.svg = self.canvas = null;
  self.width = 0;
  self.height = 0;
  self.options = null;
  self.resizer = function(width, height) {};
  
  self.setX = function(newX) {
    x = newX;
    self.data = x.data;
    
    if (x.type == "data.frame") {
      self.data = HTMLWidgets.dataframeToD3(self.data);
    }
    
    self.options = x.options;
  };
  
  self.setRoot = function(root) {
    self.root = self.svg = self.canvas = root;
  };
  
  self.setWidth = function(width) {
    self.width = width;
  };
  
  self.setHeight = function(height) {
    self.height = height;
  };
  
  self.onRender = function(renderer) {
    renderer();
  };
  
  self.onResize = function(resizer) {
    self.resizer = resizer;
  };
  
  self.resize = function(width, height) {
    self.width = width;
    self.height = height;
    self.resizer(width, height);
  };
  
  self.addScript = function(script) {
    var el = document.createElement("script");
    el.type = "text/javascript";
    el.text = script;
    document.head.appendChild(el);
  };
  
  self.addStyle = function(style) {
    if (!style) return;
    
    var el = document.createElement("style");
            
    el.type = "text/css";
    if (el.styleSheet) {
      el.styleSheet.cssText = style;
    } else {
      el.appendChild(document.createTextNode(style));
    }
    
    document.head.appendChild(el);
  };
  
  self.setVersion = function(newVersion) {
    version = newVersion;
  };
  
  self.d3 = function() {
    switch(version) {
      case 3:
        return d3v3;
      case 4:
        return d3v4;
      case 5:
        return d3v5;
    }
  };
}