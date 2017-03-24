class MaterialRaingular.d3.Directives.MrD3Bar extends AngularDirective
  @register(MaterialRaingular.d3.app)
  restrict: "E"
  require: ['?^^mrD3StackedBar','?^^mrD3HorizontalBarChart','?^^mrD3BarChart']
  transclude: true
  replace: true
  template: '<rect></rect>'
  
