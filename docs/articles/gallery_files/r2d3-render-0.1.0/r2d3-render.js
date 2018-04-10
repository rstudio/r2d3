function R2D3(el, width, height) {
  var self = this;
  var x = null;
  var version = null;
  
  self.data = null;
  self.root = self.svg = self.canvas = null;
  self.width = 0;
  self.height = 0;
  self.options = null;
  self.resizer = null;
  self.renderer = null;
  
  self.setX = function(newX) {
    x = newX;
    self.data = x.data;
    
    if (x.type == "data.frame") {
      self.data = HTMLWidgets.dataframeToD3(self.data);
    }
    
    self.options = x.options;
  };
  
  self.setContainer = function(container) {
    self.container = container;
  };
  
  self.setRoot = function(root) {
    self.root = self.svg = self.canvas = root;
  };
  
  self.createRoot = function() {
    if (self.root !== null) {
      self.d3().select(el).select(self.container).remove();
      self.root = null;
    }
    
    var root = self.d3().select(el).append(self.container)
      .attr("width", self.width)
      .attr("height", self.height);
      
    self.setRoot(root);
  };
  
  self.setWidth = function(width) {
    self.width = width;
  };
  
  self.setHeight = function(height) {
    self.height = height;
  };
  
  self.onRender = function(renderer) {
    self.renderer = renderer;
  };
  
  self.onResize = function(resizer) {
    self.resizer = resizer;
  };
  
  self.render = function() {
    if (self.renderer === null) return;
    self.renderer(self.data, self.root, self.width, self.height, self.options);
  };
  
  self.resize = function() {
    if (self.resizer === null) return;
    self.resizer(self.width, self.height);
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
        return d3;
      case 4:
        return d3v4;
      case 5:
        return d3v5;
    }
  };
  
  self.callD3Script = function() {
    var d3Script = self.d3Script;
    d3Script(self.d3(), self, self.data, self.root, self.width, self.height, self.options);
  };
  
  self.widgetRender = function(x) {
    self.setX(x);
    self.setWidth(width);
    self.setHeight(height);
    
    if (!self.root) {
      self.setVersion(x.version);
      self.addScript(x.script);
      self.addStyle(x.style);
      self.d3Script = d3Script;
      self.setContainer(x.container);
      
      self.createRoot();
      
      self.callD3Script();
    }
    
    self.render();
    
    if (self.renderer === null) {
      self.onRender(function(data, container, width, height, options) {
        self.callD3Script();
      });
    }
    
    if (self.resizer === null) {
      self.resizer = function(width, height) {
        self.createRoot();
        var d3Script = self.d3Script;
        self.callD3Script();
        self.render();
      };
    }
  };
  
  self.debounce = function(f, wait) {
    var timeout = null;
    return function() {
      if (timeout) window.clearTimeout(timeout);
      timeout = window.setTimeout(f, wait);
    };
  };
  
  self.resizeDebounce = self.debounce(self.resize, 100);
  
  self.widgetResize = function(width, height) {
    self.root
      .attr("width", width)
      .attr("height", height);

    self.setWidth(width);
    self.setHeight(height);
    
    self.resizeDebounce();
  };
}