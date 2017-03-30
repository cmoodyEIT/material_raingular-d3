class BarModel extends AngularLinkModel
  @inject('$parse')
  initialize: ->
    @parent  = @$controller.compact()[0]
    @bar     = d3.select(@$element[0])
    @label   = @$parse @$attrs.mrD3Label
    @size    = @$parse @$attrs.mrD3Value
    @options = @$parse(@$attrs.mrD3Options || '{}')
    @$scope.$watch @size.bind(@),  @changeBar.bind(@)
    @$scope.$watch @label.bind(@), @changeBar.bind(@)
    @$scope.$watch @options.bind(@), @changeOptions.bind(@), true
    @changeBar()
  changeOptions: (newVal) ->
    return unless newVal
    @bar.attr 'fill', newVal.fill || d3.interpolateCool Math.random(@index)
    @parent.adjustBars()
  changeBar: ->
    @bar.attr('raw-size',@size(@$scope))
    @bar.attr('label',   @label(@$scope))
    @changeOptions(@options(@$scope))
  @register(MaterialRaingular.d3.Directives.MrD3Bar)
