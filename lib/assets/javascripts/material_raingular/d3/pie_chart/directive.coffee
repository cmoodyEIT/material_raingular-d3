# //= require material_raingular/d3/pie_chart/controller
class MrD3PieChart extends AngularDirective
  restrict: "E"
  @register(MaterialRaingular.d3.app)
  controller: MaterialRaingular.d3.Directives.PieChartModel
  # transclude: true
  # replace: true
  # template: "<svg></svg>"
###
  Usage Slim Syntax
    mr-d3-pie-chart d3-data="{bio: 10, planning: 30, cr: 12}"
###
