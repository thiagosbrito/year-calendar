$ ->
  $.getJSON 'javascripts/json/data.json', (data) ->
    
    eventos = []
    
    validaLinguagem = (item)->
      if item.length > 1 or item.length is 0 then true else false

    for item in data
      eventos.push {
        id: item.id
        title: item.nome
        start: moment(item.dataPeriodo.dataInicio,'DD/MM/YYYY hh:mm').format()
        end: moment(item.dataPeriodo.dataFim,'DD/MM/YYYY hh:mm').format()
        institucional: item.institucional
        linguagens: validaLinguagem(item.linguagens)
        atividades: item.atividadesDTO.length
        status: item.status
        descricao: item.descricao
        color: item.cor
      }

    $('.calendario-anual').brtCalendar({
      data: eventos,
      gapYears: 20,
      period: 'monthly',
      view: 'calendar'
    })
