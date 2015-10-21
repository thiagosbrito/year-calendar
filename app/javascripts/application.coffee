eventosYear = [
  { name: "Teste 1", begin: "30/01/2015", end: "30/06/2016", color: '#c65a7a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 2", begin: "10/02/2015", end: "10/07/2016", color: '#eba825' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 3", begin: "18/03/2015", end: "10/09/2015", color: '#7155fb' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 4", begin: "30/09/2015", end: "10/12/2015", color: '#e153a5' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 5", begin: "10/01/2015", end: "25/12/2015", color: '#e04d0a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
]
eventosHalfYear = [
  { name: "Teste 1", begin: "01/07/2015", end: "30/02/2016", color: '#c65a7a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 2", begin: "01/08/2015", end: "10/12/2015", color: '#eba825' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 3", begin: "01/09/2015", end: "22/11/2015", color: '#7155fb' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 4", begin: "01/10/2015", end: "30/01/2016", color: '#e153a5' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 5", begin: "01/11/2015", end: "25/03/2016", color: '#e04d0a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 5", begin: "01/12/2015", end: "31/12/2015", color: '#e04d0a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
]
eventosQuarter = [
  { name: "Teste 1", begin: "01/10/2015", end: "20/02/2016", color: '#c65a7a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 2", begin: "02/06/2015", end: "10/10/2015", color: '#eba825' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 3", begin: "18/03/2015", end: "22/10/2015", color: '#7155fb' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
]
eventosMonth = [
  { name: "Teste 1", begin: "10/10/2015", end: "30/02/2016", color: '#c65a7a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 2", begin: "02/06/2015", end: "10/10/2015", color: '#eba825' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 3", begin: "18/03/2015", end: "22/10/2015", color: '#7155fb' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 4", begin: "15/10/2015", end: "10/12/2015", color: '#e153a5' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
  { name: "Teste 5", begin: "20/02/2015", end: "25/12/2015", color: '#e04d0a' , institutional: true , multilanguage: true, activities: 200, status: 'ativo'}
]

$ ->
  $('.calendario-anual').brtCalendar({
    data: eventosYear,
    gapYears: 1,
    period: 'monthly',
    view: 'calendar'
  })
  return

# # calcular o inicio de cada item

# # PEGA O MESMO DO EVENTO
# getInitPos = (array, spot)->
#   monthPos = 
#     positions: []

  
#   for item in array
#     dataInit = item.inicio.split "/"
#     termino = item.termino.split "/"
#     monthPos.positions.push {
#       anoInicio   : dataInit[2],
#       anoFim      : dataFim[2],
#       diaInicio   : dataInit[0],
#       diaFim      : dataFim[0],
#       mesInicio   : dataInit[1],
#       mesFim      : dataFim[1],
#       color       : item.color,
#       label       : item.nome,
#       datas       : [
#         {
#           inicio: item.dataInicio,
#           fim: item.dataFim
#         }
#       ] 
#     }
#   setProperPositions monthPos.positions,spot

# # PEGA AS POSICOES DE ONDE O ITEM ENTRARA

# # posicao inicial 
# setProperPositions = (items, spot)->

#   holder      = $(spot)
#   listMonths  = $('#yr-calendar-months-grid')[0].children
#   for item, key in items
#     larg        = $('.month-item-grid').first().width() / moment(item.mesInicio+"/"+item.anoInicio, "MM/YYYY").daysInMonth()

#     if spot is '.yearly-canvas'
#       startPos    = parseInt item.mesInicio-1
#       endPos      = parseInt item.mesFim-1
#       initP       = listMonths[startPos].offsetLeft + larg * item.diaInicio - 1
#       if parseInt(item.anoInicio) < moment().year()
#         initP       = listMonths[startPos].offsetLeft + larg * item.diaInicio - holder.width()
#       cutEnd      = parseInt item.diaFim
#       endP        = listMonths[endPos].offsetLeft + larg * cutEnd - 1
#       if parseInt(item.anoFim) > moment().year()
#         size =  endP + initP + 460
#       else
#         size =  endP - initP
#         # initP       = listMonths[startPos].offsetLeft + larg * item.diaInicio - 1

#     if spot is '.half-yearly-canvas'
#       startPos    = parseInt item.mesInicio-1
#       endPos      = parseInt item.mesFim-1
#       initP       = listMonths[startPos].offsetLeft + larg * item.diaInicio - 1
#       if parseInt(item.anoInicio) < moment().year()
#         initP       = listMonths[startPos].offsetLeft + larg * item.diaInicio - holder.width()
#       cutEnd      = parseInt item.diaFim
#       endP        = listMonths[endPos].offsetLeft + larg * cutEnd - 1
#       if parseInt(item.anoFim) > moment().year()
#         size =  endP + initP + 460
#       else
#         size =  endP - initP
    
#     # if spot is '.quarterly-canvas'
    
#     # if spot is '.monthly-canvas'
    

#     holder.append("
#       <div class='item'
#         id='calendar-item-#{key}'
#         data-toggle='popover'
#         data-content='Data de inicio: #{item.datas[0].inicio} <br> Data de Encerramento: #{item.datas[0].fim}'
#         data-original-title='#{item.label}'
#         style='left:#{initP}px; width:#{size}px; background-color:#{item.color}'>
#         <span>"+moment(item.datas[0].inicio,'DD/MM/YYYY').locale('pt-br').format('DD MMM')+" - "+moment(item.datas[0].fim,'DD/MM/YYYY').locale('pt-br').format('DD MMM')+"</span><br>
#         <span>#{item.label}</span>
#       </div>
#     ");

#     $('#calendar-item-'+key).popover({
#       placement: (tip, element) ->
#         offset = $(element).offset()
#         height = $('#yr-calendar-schedules-canvas').outerHeight()
#         width = $('#yr-calendar-schedules-canvas').outerWidth()
#         vert = 2 * height - (offset.top)
#         vertPlacement = if vert > 0 then 'bottom' else 'top'
#         horiz = 0.5 * width - (offset.left)
#         horizPlacement = if horiz > 0 then 'right' else 'left'
#         placement = if Math.abs(horiz) > Math.abs(vert) then horizPlacement else vertPlacement
#         placement
#       html: true,
#       trigger: 'hover'
#     })

  # getInitPos(eventosYear,'.yearly-canvas')
  # getInitPos(eventosHalfYear,'.half-yearly-canvas')
  # getInitPos(eventosQuarter,'.quarterly-canvas')
  # getInitPos(eventosMonth,'.monthly-canvas')

  # changeCalendarView = ()->
  #   $('.btn-yr-calendar').removeClass('active')
  #   $(@).addClass('active')
  #   mode = $(@).data('view-mode')
  #   $('.yr-calendar-spot').hide()
  #   $('#yr-calendar-schedules-canvas').hide()
  #   $('.yr-calendar-'+mode).show()
  #   $('.'+mode+'-canvas').show()

  # $('.btn-yr-calendar').click(changeCalendarView)