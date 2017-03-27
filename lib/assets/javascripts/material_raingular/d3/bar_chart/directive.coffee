# //= require material_raingular/d3/horizontal_bar_chart/controller
class MrD3BarChart extends AngularDirective
  @register(MaterialRaingular.d3.app)
  restrict: "E"
  controller: MaterialRaingular.d3.Directives.MrD3BarChartModel
  transclude: true
  replace: true
  template: "<svg height='100%' width='100%'><g ng-transclude></g></svg>"
###
  Usage Slim syntax
  mr-d3-bar-chart.test ng-init="dataSet = [{l: 'a',v: 23},{l: 'b',v: 13},{l: 'c',v: 21},{l: 'd',v: 14},{l: 'e',v: 37},{l: 'f',v: 15},{l: 'g',v: 18},{l: 'h',v: 34},{l: 'i',v: 30}]"
    mr-d3-bar.thingy ng-repeat="data in dataSet" mr-d3-label="data.l" mr-d3-value="data.v"
    mr-d3-bar mr-d3-label="'this'" mr-d3-value="'200'"
    mr-d3-y-axis ng-init="domain = [37,0]" mr-d3-label="'Value'" mr-d3-domain='domain'

    mr-d3-stacked-bar mr-d3-label="'CA'"
      mr-d3-bar ng-repeat="data in [10,4,7]" mr-d3-label="data" mr-d3-value="data"
    mr-d3-stacked-bar mr-d3-label="'AZ'"
      mr-d3-bar ng-repeat="data in [10,4,7]" mr-d3-label="data" mr-d3-value="data"
    mr-d3-x-axis mr-d3-label="'Arbitrary'"
###
