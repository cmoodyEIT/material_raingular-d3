class BarModel extends AngularLinkModel
  @inject('$interpolate')
  initialize: ->
    height = @$interpolate(@$element.find('value').html())(@$scope)
    data = {height: parseFloat(height) * 10,width: 40}
    @$controller.append(data)
  @register(MaterialRaingular.d3.Directives.MrD3Bar)
