class PieSliceModel extends AngularLinkModel
  @inject('$parse')
  initialize: ->
    @options    = @$parse(@$attrs.mrD3Options || '{}')
    @slice      = d3.select(@$element[0])
    @index      = @$controller.addSlice(@)
    @path       = @slice.append('path').attr("id", 'arc-' + @index).attr('stroke', '#FFF')
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
    bbox = @text.node().getBBox()
    topLeft =
      x : x + bbox.x,
      y : y + bbox.y
    topRight =
      x : topLeft.x + bbox.width,
      y : topLeft.y
    bottomLeft =
      x : topLeft.x,
      y : topLeft.y + bbox.height
    bottomRight =
      x : topLeft.x + bbox.width,
      y : topLeft.y + bbox.height
    visible = _pointIsInArc(topLeft, @$controller, @index) &&
              _pointIsInArc(topRight, @$controller, @index) &&
              _pointIsInArc(bottomLeft, @$controller, @index) &&
              _pointIsInArc(bottomRight, @$controller, @index)
    @text.attr('display', 'none') unless visible
  removeSlice: -> @$controller.removeSlice(@)
  afterDraw: ->
    @adjustText()
  _mouseOver: ->
    d3.select("#tip-#{@index}#{@valueFn(@$scope).toFixed()}")
      .classed('hidden', false)
      .style('left',(d3.event.pageX + 10) + 'px')
      .style('top', (d3.event.pageY + 10) + 'px')
  _mouseMove: (d, i) ->
    d3.select("#tip-#{@index}#{@valueFn(@$scope).toFixed()}")
      .style('left',(d3.event.pageX + 10) + 'px')
      .style('top', (d3.event.pageY + 10) + 'px')
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
  _pointIsInArc = (pt, controller, index) ->
    r1 = 0
    r2 = controller.chartHeight / 2
    theta1 = controller.arcs[index].startAngle
    theta2 = controller.arcs[index].endAngle
    dist = pt.x * pt.x + pt.y * pt.y
    angle = Math.atan2(pt.x, -pt.y)
    angle = if angle < 0 then angle + Math.PI * 2 else angle
    r1 * r1 <= dist && dist <= r2 * r2 && theta1 <= angle && angle <= theta2

  @register(MaterialRaingular.d3.Directives.MrD3PieSlice)
