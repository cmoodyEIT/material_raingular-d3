class BarModel extends AngularLinkModel
  @inject('$interpolate')
  initialize: ->
    @parent = @$controller.compact()[0]
    @size    = @$interpolate(@$element.find('value').html())
    @label   = @$interpolate(@$element.find('label').html())
    @$scope.$watch @size.bind(@),  @adjustSize.bind(@)
    @$scope.$watch @label.bind(@), @adjustSize.bind(@)
    if bar = @parent.bars().nodes()[@$scope.$index]
      @parent.$ignoreDestroy.push(@$scope.$index)
      @bar = d3.select(bar)
      @adjustSize(true)
    else
      @bar   = @parent.append({size: parseFloat(@size(@$scope)),label: @label(@$scope),class: @$attrs.class},@$scope.$index)
    @$element.on '$destroy', @removeBar.bind(@)
  adjustSize: (newVal,oldVal) ->
    return if newVal == oldVal
    @parent.adjustSize(@bar,@size(@$scope),@label(@$scope),@$scope.$index)
  removeBar: (event) ->
    if @parent.$ignoreDestroy.includes(@$scope.$index)
      @parent.$ignoreDestroy.drop(@$scope.$index)
      return
    @parent.removeBar(@bar,@$scope.index)
  @register(MaterialRaingular.d3.Directives.MrD3Bar)
