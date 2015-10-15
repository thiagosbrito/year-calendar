eventos = [
  { nome: "Teste 1", dataInicio: "30/01/2014", dataFim: "30/01/2015", color: 'red' }
  { nome: "Teste 2", dataInicio: "10/02/2015", dataFim: "10/07/2015", color: 'blue' }
  { nome: "Teste 3", dataInicio: "18/03/2015", dataFim: "10/09/2015", color: 'green' }
  { nome: "Teste 4", dataInicio: "30/09/2015", dataFim: "10/12/2015", color: 'orange' }
  { nome: "Teste 5", dataInicio: "10/01/2015", dataFim: "25/12/2015", color: 'yellow' }
]

# calcular o inicio de cada item
monthPos = 
  positions: []
# PEGA O MESMO DO EVENTO
getInitPos = ()->

  for item in eventos
    dataInit = item.dataInicio.split "/"
    dataFim = item.dataFim.split "/"
    monthPos.positions.push {
      ano: dataInit[2],
      diaInicio: dataInit[0],
      diaFim: dataFim[0],
      mesInicio: dataInit[1],
      mesFim:dataFim[1],
      color: item.color,
      label: item.nome,
      datas: [
        {
          inicio: item.dataInicio,
          fim: item.dataFim
        }
      ] 
    }
  setProperPositions monthPos.positions

# PEGA AS POSICOES DE ONDE O ITEM ENTRARA

# posicao inicial 
setProperPositions = (items)->

  holder      = $('#yr-calendar-schedules-canvas')
  grid        = $('#yr-calendar-months-grid')
  larg        = $('.month-item-grid').first().width() / 30 # usar o moment para pegar a qtd de dias do mes da coluna
  listMonths = grid[0].children

  for item, key in items
    
    startPos    = parseInt item.mesInicio-1
    endPos      = parseInt item.mesFim-1
    initP       = listMonths[startPos].offsetLeft + larg * item.diaInicio - 1
    if parseInt(item.ano) < moment().year()
      initP       = listMonths[startPos].offsetLeft + larg * item.diaInicio - holder.width()
    cutEnd      = parseInt item.diaFim
    endP        = listMonths[endPos].offsetLeft + larg * cutEnd - 1

    size =  endP - initP

    

    holder.append("<div class='item'
      id='calendar-item-#{key}'
      data-toggle='popover'
      data-content='Data de inicio: #{item.datas[0].inicio} <br> Data de Encerramento: #{item.datas[0].fim}'
      data-original-title='#{item.label}'
      style='left:#{initP}px; width:#{size}px; background-color:#{item.color}'>
    ");

    $('#calendar-item-'+key).popover({
      placement: (tip, element) ->
        offset = $(element).offset()
        height = $('#yr-calendar-schedules-canvas').outerHeight()
        width = $('#yr-calendar-schedules-canvas').outerWidth()
        vert = 2 * height - (offset.top)
        vertPlacement = if vert > 0 then 'bottom' else 'top'
        horiz = 0.5 * width - (offset.left)
        horizPlacement = if horiz > 0 then 'right' else 'left'
        placement = if Math.abs(horiz) > Math.abs(vert) then horizPlacement else vertPlacement
        placement
      html: true,
      trigger: 'hover'
    })

$ ->
  do getInitPos

  changeCalendarView = ()->
    $('.btn-yr-calendar').removeClass('active')
    $(@).addClass('active')
    mode = $(@).data('view-mode')
    $('.yr-calendar-spot').hide()
    $('.yr-calendar-'+mode).show()

  $('.btn-yr-calendar').click(changeCalendarView)



  
  
    

