class MaterialRaingular.d3.Directives.MrD3PieSlice extends AngularDirective
  restrict: "E"
  @register(MaterialRaingular.d3.app)
  controller: MaterialRaingular.d3.Directives.PieChartModel
  replace: true
  require: '^mrD3PieChart'
  template: "<g class='arc'></g>"
###
  Usage Slim Syntax
    mr-d3-pie-chart d3-data="{bio: 10, planning: 30, cr: 12}"
###
