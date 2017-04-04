class PieSliceModel extends AngularLinkModel
  @inject('$parse')
  initialize: ->
    @options    = @$parse(@$attrs.mrD3Options || '{}')
    @slice      = d3.select(@$element[0])
    @index      = @$controller.addSlice(@)
    @path       = @slice.append('path').attr('id', 'arc-' + @index)
    @transition = d3.transition().duration(300).ease(d3.easeLinear)
    @labelFn    = @$parse @$attrs.mrD3Label
    @valueFn    = @$parse @$attrs.mrD3Value
    @adjustSlice()
    @addText()
    @$scope.$watch @valueFn.bind(@), @changeValue.bind(@)
    @$scope.$watch @labelFn.bind(@), @adjustText.bind(@)
    @$scope.$watch @options.bind(@), @changeOptions.bind(@), true
    @$scope.$on '$destroy', @removeSlice.bind(@)
  changeOptions: (newVal) ->
    return unless newVal
    @path.attr 'fill', newVal.fill || d3.interpolateCool Math.random(@index)
  changeValue: (newVal,oldVal) ->
    return unless newVal
    @index = @$controller.changeData(@,newVal)
  adjustSlice: ->
    @slice.attr('transform', "translate(#{[@$controller.chartWidth / 2,@$controller.chartHeight / 2]})")
    .on('mouseover', @_mouseOver.bind(@))
    .on('mouseout',  @_mouseOut.bind(@))
    .on('mousemove', @_mouseMove.bind(@))
    .on('click',     @_click.bind(@))
  addText: ->
    @text = @slice.append('text')
    .style('text-anchor', 'middle')
    .style('pointer-events', 'none')
    .style('fill', '#fff')
    .attr('dy', '.35em')
  adjustText: ->
    return unless @$controller.arcs && @index != undefined
    data = @$controller.arcs[@index]
    centroid = @$controller.arc.centroid(data)
    x = centroid[0]
    y = centroid[1]
    @text.attr 'transform', "translate(#{x},#{y})"
    .text @labelFn(@$scope)
  removeSlice: -> @$controller.removeSlice(@)
  afterDraw: ->
    @adjustText()
  _mouseOver: ->
    d3.select("#tip-#{@index}#{@valueFn(@$scope).toFixed()}")
      .classed('hidden', false)
      .style('left', d3.event.pageX + 'px')
      .style('top', ((d3.event.pageY - 80 ) / 2) + 'px')
  _mouseMove: (d, i) ->
    d3.select("#tip-#{@index}#{@valueFn(@$scope).toFixed()}")
      .style('left', d3.event.pageX + 'px')
      .style('top', ((d3.event.pageY - 80 ) / 2) + 'px')
  _mouseOut: (d, i) ->
    d3.select("#tip-#{@index}#{@valueFn(@$scope).toFixed()}").classed('hidden', true)
  _click: ->
    paths = @$controller.chartLayer.selectAll('path')
    paths.selectAll('animateTransform').remove()
    reduce = !@path.attr('transform') || (@path.attr('transform').strip() == "translate(0,0)scale(1,1)")
    paths.transition(@transition).attr('transform',"translate(0,0) scale(1,1)")
    return unless reduce
    theta = (@$controller.arcs[@index].endAngle + @$controller.arcs[@index].startAngle)/2
    x = 10 * Math.cos (Math.PI / 2) - theta
    y = -10 * Math.sin (Math.PI / 2) - theta
    @path.transition(@transition).attr('transform',"translate(#{x},#{y}) scale(1.25,1.25)")

  @register(MaterialRaingular.d3.Directives.MrD3PieSlice)
