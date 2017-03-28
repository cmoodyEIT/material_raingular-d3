class BarModel extends AngularLinkModel
  @inject('$parse')
  initialize: ->
    @options = @$scope.$eval(@$attrs.mrD3Options || '{}')
    @parent = @$controller.compact()[0]
    @bar = d3.select(@$element[0])
    .attr 'fill', @options.fill || d3.interpolateCool Math.random()
    @label = @$parse @$attrs.mrD3Label
    @size  = @$parse @$attrs.mrD3Value
    @$scope.$watch @size.bind(@),  @changeBar.bind(@)
    @$scope.$watch @label.bind(@), @changeBar.bind(@)
    @changeBar()
  changeBar: ->
    @bar.attr('raw-size',@size(@$scope))
    @bar.attr('label',   @label(@$scope))
    @parent.adjustBars()
  @register(MaterialRaingular.d3.Directives.MrD3Bar)
