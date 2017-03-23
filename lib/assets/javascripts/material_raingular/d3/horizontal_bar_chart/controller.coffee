class MaterialRaingular.d3.Directives.MrD3HorizontalBarChartModel extends AngularDirectiveModel
  @inject('$timeout','$element','$attrs')
  initialize: ->
    @options = @$scope.$eval(@$attrs.d3Options || '{}')
    @options.margins = Object.merge({top: 20,right: 20, left: 70, bottom: 50},@options.margins || {})
    @svg = d3.select(@$element[0]).append('svg')
    @svg.attr('height', "100%").attr('width', "100%")
    @svg.append('g').attr('transform',"translate(#{@options.margins.left},#{@options.margins.right})")
    @band = d3.scaleBand().range([0,@height()]).padding(0.05)
    @yAxis = @svg.append('g').attr('transform',"translate(#{@options.margins.left},#{@options.margins.top})")
    @yDomain = []
  $ignoreDestroy: []

  bars:     -> @svg.selectAll('rect')
  size:     -> @bars().size()
  height:   -> @$element[0].offsetHeight - @options.margins.top  - @options.margins.bottom
  width:    -> @$element[0].offsetWidth  - @options.margins.left - @options.margins.right
  maxValue: ->
    val   = @_xAxis?.domain().max()
    val ||= (@bars().nodes().map (rect) -> d3.select(rect).attr('bar-size')).max()
    val
  append: (bar,index) ->
    @yDomain[index] = (bar.label || index)
    rect = @svg.select('g').append('rect')
    rect.attr('class',"bar #{bar.class}")
    rect.attr('bar-size',bar.size)
    @band.domain(angular.copy(@yDomain).reverse())
    @adjustWidths()
    @adjustHeights()
    @yAxis.call(d3.axisLeft(@band))
    rect
  appendXAxis: (domain)->
    x = d3.scaleLinear().range([0,@width()])
    x.domain(domain)
    @xAxis = @svg.append('g')
    .attr('transform',"translate(#{@options.margins.left},#{@height() + @options.margins.top})")
    .call(d3.axisBottom(x))
    @_xAxis = x
  adjustXAxis: (axis,domain) ->
    axis.domain(domain)
    @xAxis.call(d3.axisBottom(axis))
    @adjustWidths()
  adjustSize: (bar,size,label,index) ->
    @yDomain[index] = label
    @band.domain(angular.copy(@yDomain).reverse())
    @yAxis.call(d3.axisLeft(@band))
    bar.attr('bar-size',size)
    @adjustWidths()
  removeBar: (bar,index)->
    bar.remove()
    @yDomain.splice(index,1)
    @band.domain(angular.copy(@yDomain).reverse())
    @yAxis.call(d3.axisLeft(@band))
    @adjustWidths()
    @adjustHeights()
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
