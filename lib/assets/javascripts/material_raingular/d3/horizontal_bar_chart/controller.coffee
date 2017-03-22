class MaterialRaingular.d3.Directives.MrD3HorizontalBarChartModel extends AngularDirectiveModel
  @inject('$timeout','$element')
  initialize: ->
    window.thisSvg = @svg = d3.select(@$element[0]).append('svg').attr('height', '100%').attr('width', '100%')
  append: (bar) ->
    rect = @svg.append('rect')
    rect.attr('class','bar')
    rect.attr('bar-height',bar.height)
    @adjustWidths()
    @adjustHeights()
  bars:   -> @svg.selectAll('rect')
  size:   -> @bars().size()
  height: -> @$element[0].offsetHeight
  width:  -> @$element[0].offsetWidth
  adjustWidths: ->
    for rect,i in @bars().nodes()
      d3.select(rect).attr('width',@width()/@size() * 0.67)
      d3.select(rect).attr('x',(i + 0.33) * (@width()/@size()))
  adjustHeights: ->
    maxHeight = (@bars().nodes().map (rect) -> d3.select(rect).attr('bar-height')).max() * 1.1
    for bar,i in @bars().nodes()
      rect = d3.select(bar)
      height = (rect.attr('bar-height') / maxHeight) * @height()
      rect.attr('height',height)
      rect.attr('y',@height() - height)

    # dataArray = [23,13,21,14,37,15,18,34,30]
    # # Create variable for the SVG
    # # svg = d3.select('body').append('svg').attr('height', '100%').attr('width', '100%')
    # # Select, append to SVG, and add attributes to rectangles for bar chart
    # @svg.selectAll('rect')
    # .data(dataArray)
    # .enter()
    # .append('rect')
    # .attr('class', 'bar')
    # .attr('height', (d, i) -> d * 10)
    # .attr('width', '40')
    # .attr('x', (d, i) -> i * 60 + 25)
    # .attr 'y', (d, i) -> 400 - (d * 10)
    # # Select, append to SVG, and add attributes to text
    # @svg.selectAll('text').data(dataArray).enter().append('text').text((d) ->
    #   d
    # ).attr('class', 'text').attr('x', (d, i) ->
    #   i * 60 + 36
    # ).attr 'y', (d, i) ->
    #   415 - (d * 10)
  # @register(Directives.HorizontalBarChart)
