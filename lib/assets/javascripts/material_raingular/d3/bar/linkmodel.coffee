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
    @bar.on('mouseover', @_mouseOver.bind(@))
      .on('mouseout',  @_mouseOut.bind(@))
      .on('mousemove', @_mouseMove.bind(@))
  _mouseOver: ->
    d3.select("#tip-#{@parent.indexOf(@bar._groups[0][0])}#{parseFloat(@size(@$scope)).toFixed()}")
      .classed('hidden', false)
      .style('left',(d3.event.pageX + 10) + 'px')
      .style('top', (d3.event.pageY + 10) + 'px')
  _mouseMove: (d, i) ->
    d3.select("#tip-#{@parent.indexOf(@bar._groups[0][0])}#{parseFloat(@size(@$scope)).toFixed()}")
      .style('left',(d3.event.pageX + 10) + 'px')
      .style('top', (d3.event.pageY + 10) + 'px')
  _mouseOut: (d, i) ->
    d3.select("#tip-#{@parent.indexOf(@bar._groups[0][0])}#{parseFloat(@size(@$scope)).toFixed()}").classed('hidden', true)
  @register(MaterialRaingular.d3.Directives.MrD3Bar)
