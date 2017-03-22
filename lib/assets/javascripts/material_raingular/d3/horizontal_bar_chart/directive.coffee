# //= require material_raingular/d3/horizontal_bar_chart/controller
class MrD3HorizontalBarChart extends AngularDirective
  @register(MaterialRaingular.d3.app)
  restrict: "E"
  controller: MaterialRaingular.d3.Directives.MrD3HorizontalBarChartModel
  transclude: true
  template: "<div ng-transclude></div>"
  # template: ->
  #   "<svg height='100%' width='100%'>
  #     <rect class='bar' height='230' width='40' x='25' y='170'></rect></svg>"
