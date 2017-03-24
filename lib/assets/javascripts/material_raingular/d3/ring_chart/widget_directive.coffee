# //= require material_raingular/d3/ring_chart/widget_controller
class MrD3RingWidget extends AngularDirective
  restrict: 'E'
  transclude: true
  templateUrl: 'assets/material_raingular/d3/ring_chart/ringWidget.html'
  scope: {}
  controller: MaterialRaingular.d3.Directives.MrD3RingWidget
  @register(MaterialRaingular.d3.app)
###
  Usage Slim Syntax
    mr-d3-ring-widget
      h3
        | Bio Billability
      mr-d3-ring ring-data="[50,10]"
