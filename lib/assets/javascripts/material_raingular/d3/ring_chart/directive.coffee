class MaterialRaingular.d3.Directives.MrD3Ring extends AngularDirective
  restrict: "E"
  require: "^^mrD3RingWidget"
  templateUrl: "assets/material_raingular/d3/ring_chart/ring.html"
  scope: {
    ringData: "@"
    title: "@"
  }
  @register(MaterialRaingular.d3.app)
