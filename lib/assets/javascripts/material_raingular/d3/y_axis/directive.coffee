class MaterialRaingular.d3.Directives.MrD3YAxis extends AngularDirective
  @register(MaterialRaingular.d3.app)
  restrict: "E"
  require: ['?^mrD3HorizontalBarChart','?^mrD3BarChart']
  transclude: true
  replace: true
  template: "<g class='y axis'></g>"
