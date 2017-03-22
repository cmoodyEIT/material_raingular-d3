class MaterialRaingular.d3.Directives.MrD3Bar extends AngularDirective
  @register(MaterialRaingular.d3.app)
  restrict: "E"
  require: '^^mrD3HorizontalBarChart'
  transclude: true
  template: "<span style='display:none' ng-transclude></span>"
  # controller: DirectiveModels.HorizontalBarChartModel
  # template: ->
  #   "<svg height='100%' width='100%'>
  #     <rect class='bar' height='230' width='40' x='25' y='170'></rect></svg>"
