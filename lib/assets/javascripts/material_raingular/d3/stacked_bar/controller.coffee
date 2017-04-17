class MaterialRaingular.d3.Directives.MrD3StackedBar extends AngularDirectiveModel
  @inject('$parse','$element')
  initialize: ->
    @parent  = @$element.parent().controller('mrD3BarChart')
    @direction = if @parent then 'vertical' else 'horizontal'
    @parent ?= @$element.parent().controller('mrD3HorizontalBarChart')
    @bar     = d3.select(@$element[0])
    @label   = @$parse @$element.attr('mr-d3-label')
    @stacked = @$parse @$element.attr('mr-d3-stacked')
    @texts   = []
    @$scope.$watch @label.bind(@), @adjustBars.bind(@)
    @$scope.$watch @size.bind(@),  @adjustBars.bind(@)
    @$scope.$watch @stacked.bind(@),  @adjustBars.bind(@)
    @$scope.$on '$destroy', @removeText.bind(@)
    @adjustBars()
  bars: -> @bar.selectAll('rect')
  size: -> if @direction == 'vertical' then @bar.attr('height') else @bar.attr('width')
  rawSize: -> (@bars().nodes().map (rect) => d3.select(rect).attr('raw-size')).sum()
  removeText: ->
    text.remove() for text in @texts
    @adjustBars()
  adjustBars: ->
    @bar.attr('raw-size',@rawSize() || 0)
    @bar.attr('label',   @label(@$scope))
    @parent.adjustBars()
    width  = @bar.attr('width')
    height = @bar.attr('height')
    x      = @bar.attr('x')
    y      = @bar.attr('y')
    usedSpace = 0
    key = @bar.node().$$hashKey?.replace(':','_') #TODO: Not Dependable
    fill = null
    fillRegex = /.*\(([0-9]+\, [0-9]+\, [0-9]+).*\)/
    @parent.holder.selectAll("text.bar.#{key}").remove()
    length = @bars().nodes().length
    nonzero = 0
    for rect,i in @bars().nodes()
      nonzero += 1 if d3.select(rect).attr('raw-size') > 0
    for rect,i in @bars().nodes()
      bar = d3.select(rect)
      bar.attr('class',"#{i} bar")
      fill = fill || bar.attr('fill')?.match(fillRegex)?[1] || '0,0,0'
      bar.attr('fill',"rgba(#{fill},#{1 - i/length})")
      parentLabel = rect.parentNode.attributes['label'].value.slice(-2)
      bar.on('mouseover', @_mouseOver.bind(null,rect,i,parentLabel))
        .on('mouseout',  @_mouseOut.bind(null,rect,i,parentLabel))
        .on('mousemove', @_mouseMove.bind(null,rect,i,parentLabel))
      text = @parent.holder.append('text')
      .style("text-anchor","middle")
      .style("fill", "#FFF")
      .attr('class',"#{i} bar text #{key}")
      .text(bar.attr('label'))
      @texts.push(text)
      if @direction == 'vertical'
        ratio = height / @bar.attr('raw-size')
        barHeight = ratio * bar.attr('raw-size')
        bar.attr('height',barHeight || 0)
        if @stacked(@$scope)
          usedSpace += barHeight || 0
          bar.attr('x',x)
          bar.attr('width',width || 0)
          bar.attr('y',@parent.height() - usedSpace)
        else
          barWidth = width / nonzero
          bar.attr('width', barWidth)
          bar.attr('x', parseFloat(x) + usedSpace)
          bar.attr('y', @parent.height() - barHeight)
          usedSpace += barWidth if barHeight > 0
        text.attr('x', -parseFloat(bar.attr('y')) - parseFloat(bar.attr('height'))/2)
        .attr('y',parseFloat(bar.attr('x')) + parseFloat(bar.attr('width'))/2 + 5)
        .attr('transform','rotate(-90)')
        bbox = text.node().getBBox()
        if (bbox.width > barHeight) || (bbox.height > width || barWidth)
          text.style('display','none')
        else
          text.style('pointer-events', 'none').style('display', 'block')
      else
        ratio = width / @bar.attr('raw-size')
        barWidth = ratio * bar.attr('raw-size')
        bar.attr('width',barWidth || 0)
        if @stacked(@$scope)
          bar.attr('y',y)
          bar.attr('height',height || 0)
          bar.attr('x',usedSpace)
          usedSpace += barWidth || 0
        else
          barHeight = height / nonzero
          bar.attr('y',parseFloat(y) + usedSpace)
          bar.attr('height',barHeight)
          bar.attr('x',0)
          usedSpace += barHeight if barWidth > 0
        text.attr('x', parseFloat(bar.attr('width' || 0))/2 + parseFloat(bar.attr('x')))
        .attr('y',parseFloat(bar.attr('y')) + parseFloat(bar.attr('height'))/2 + 5)
        bbox = text.node().getBBox()
        if bbox.width > barWidth || (bbox.height > height || barHeight)
          text.style('display', 'none')
        else
          text.style('pointer-events', 'none').style('display', 'block')
  _mouseOver: (d,i,parentLabel) ->
    d3.select("#tip-table-" + parentLabel)
      .classed('hidden', false)
      .style('left', (d3.event.pageX + 10) + 'px')
      .style('top', (d3.event.pageY + 10) + 'px')
      .select("#tip-" + i).classed('hidden', false)
  _mouseMove: (d,i,parentLabel) ->
    d3.select("#tip-table-" + parentLabel)
      .style('left', (d3.event.pageX + 10) + 'px')
      .style('top', (d3.event.pageY + 10) + 'px')
  _mouseOut: (d,i,parentLabel) ->
    d3.select("#tip-table-" + parentLabel)
      .classed('hidden', true)
      .select("#tip-" + i).classed('hidden', true)
