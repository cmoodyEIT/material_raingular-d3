class MaterialRaingular.d3.Directives.MrD3StackedBar extends AngularDirectiveModel
  @inject('$parse','$element')
  initialize: ->
    @parent  = @$element.parent().controller('mrD3BarChart')
    @direction = if @parent then 'vertical' else 'horizontal'
    @parent ?= @$element.parent().controller('mrD3HorizontalBarChart')
    @bar     = d3.select(@$element[0])
    @label   = @$parse @$element.attr('mr-d3-label')
    @$scope.$watch @label.bind(@), @adjustBars.bind(@)
    @$scope.$watch @size.bind(@),  @adjustBars.bind(@)
    @adjustBars()
  bars: -> @bar.selectAll('rect')
  size: -> if @direction == 'vertical' then @bar.attr('height') else @bar.attr('width')
  rawSize: -> (@bars().nodes().map (rect) => d3.select(rect).attr('raw-size')).sum()
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
    @parent.holder.selectAll("text.bar.#{key}").remove()
    for rect,i in @bars().nodes()
      bar = d3.select(rect)
      bar.attr('class',"#{i} bar")
      bar.attr('fill',"rgba(1,1,1,#{1 - (0.1 * i)})")
      text = @parent.holder.append('text')
      .style("text-anchor","middle")
      .attr('class',"#{i} bar text #{key}")
      .text(bar.attr('label'))
      if @direction == 'vertical'
        ratio = height / @bar.attr('raw-size')
        barHeight = ratio * bar.attr('raw-size')
        usedSpace += barHeight
        bar.attr('x',x)
        bar.attr('width',width)
        bar.attr('y',@parent.height() - usedSpace)
        bar.attr('height',barHeight)
        text.attr('x', -parseFloat(bar.attr('y')) - parseFloat(bar.attr('height'))/2)
        .attr('y',parseFloat(bar.attr('x')) + parseFloat(bar.attr('width')))
        .attr('transform','rotate(-90)')
      else
        ratio = width / @bar.attr('raw-size')
        barWidth = ratio * bar.attr('raw-size')
        bar.attr('y',y)
        bar.attr('height',height)
        bar.attr('x',usedSpace)
        bar.attr('width',barWidth)
        usedSpace += barWidth
        text.attr('x', parseFloat(bar.attr('width'))/2 + parseFloat(bar.attr('x')))
        .attr('y',parseFloat(bar.attr('y')) + parseFloat(bar.attr('height')))
