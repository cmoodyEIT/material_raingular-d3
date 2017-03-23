class MaterialRaingular.d3.Directives.MrD3HorizontalBarChartModel extends AngularDirectiveModel
  @inject('$timeout','$element','$attrs')
  initialize: ->
    @options = @$scope.$eval(@$attrs.d3Options || '{}')
    @options.margins = Object.merge({top: 20,right: 20, left: 70, bottom: 50},@options.margins || {})
    window.thisSvg = @svg = d3.select(@$element[0]).append('svg')
    @svg.attr('height', "100%").attr('width', "100%")
    @svg.append('g').attr('transform',"translate(#{@options.margins.left},#{@options.margins.right})")
    @band = d3.scaleBand().range([0,@height()]).padding(0.05)
    @yAxis = @svg.append('g').attr('transform',"translate(#{@options.margins.left},#{@options.margins.top})")
    @yDomain = []
  append: (bar) ->
    @yDomain.push(bar.label || @yDomain.length)
    rect = @svg.select('g').append('rect')
    rect.attr('class','bar')
    rect.attr('bar-size',bar.size)
    @band.domain(@yDomain)
    @adjustWidths()
    @adjustHeights()
    @yAxis.call(d3.axisLeft(@band))
  bars:   -> @svg.selectAll('rect')
  size:   -> @bars().size()
  height: -> @$element[0].offsetHeight - @options.margins.top  - @options.margins.bottom
  width:  -> @$element[0].offsetWidth  - @options.margins.left - @options.margins.right
  maxValue: ->
    (@bars().nodes().map (rect) -> d3.select(rect).attr('bar-size')).max()
  adjustWidths: ->
    for bar,i in @bars().nodes()
      rect = d3.select(bar)
      width = (rect.attr('bar-size') / @maxValue()) * @width()
      rect.attr('width',width)
      rect.attr('x',0)
  adjustHeights: ->
    for rect,i in @bars().nodes()
      d3.select(rect).attr('height',@band.bandwidth())
      d3.select(rect).attr('y',@band(@yDomain[i]))
