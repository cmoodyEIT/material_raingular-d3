class BarModel extends AngularLinkModel
  @inject('$interpolate')
  initialize: ->
    height = @$interpolate(@$element.find('value').html())(@$scope)
    label  = @$interpolate(@$element.find('label').html())(@$scope)
    @$controller.compact()[0].append({size: parseFloat(height),label: label})
  @register(MaterialRaingular.d3.Directives.MrD3Bar)
