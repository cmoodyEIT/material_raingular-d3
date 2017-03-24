# //= require material_raingular/d3/stacked_bar/controller
class MaterialRaingular.d3.Directives.mrD3StackedBar extends AngularDirective
  @register(MaterialRaingular.d3.app)
  restrict: "E"
  require: ['?^^mrD3HorizontalBarChart','?^^mrD3BarChart']
  controller: MaterialRaingular.d3.Directives.MrD3StackedBar
  transclude: true
  replace: true
  template: "<g class='stacked bar' ng-transclude></rect>"
