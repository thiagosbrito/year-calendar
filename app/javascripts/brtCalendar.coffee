(($) ->

  $.fn.brtCalendar = (options) ->
    
    settings = $.extend({
      data: null
      view: null
      period: null
      gapYears: null
    }, options)

    if settings.period is null
      settings.period = 'yearly'
    if settings.view is null
      settings.view = 'calendar'
    if settings.gapYears is null
      settings.gapYears = 20

    minMonth = 0
    maxMonth = 11

    viewMode = settings.period

    year = moment().year()
    minYear = year - settings.gapYears
    maxYear = year + settings.gapYears

    listMonths = moment.months()

    # templates definitions
    $templateHeader               = null
    # templates for calendar
    $templateCalendarYearly       = null   
    $templateCalendarMonthly      = null
    $templateCalendarQuarterly    = null
    $templateCalendarHalfYearly   = null
    # templates for lists
    $templateListYearly           = null   
    $templateListMonthly          = null
    $templateListQuarterly        = null
    $templateListHalfYearly       = null

    # set cache for dom templates
    cacheDom = ()=>
      $templateHeader               = $(templates['header'])
      # templates for calendar
      $templateCalendarYearly       = $(templates['calendar-yearly'])
      $templateCalendarHalfYearly   = $(templates['calendar-half-yearly'])
      $templateCalendarQuarterly    = $(templates['calendar-quarterly'])
      $templateCalendarMonthly      = $(templates['calendar-monthly'])
      # templates for lists
      $templateListYearly           = $(templates['list-yearly'])
      $templateListHalfYearly       = $(templates['list-half-yearly'])
      $templateListQuarterly        = $(templates['list-quarterly'])
      $templateListMonthly          = $(templates['list-monthly'])

    # render templates at html file
    buildTemplate = ()=>

      # by default the calendar its always open in a calendar view instead of list view
      $(this).append $templateHeader

      # remove active class for all buttons
      $templateHeader.find('.btn-yr-calendar').removeClass 'active'
      $templateHeader.find('.t-view').removeClass 'active'

      # set active the setting comming from plugin instatiate 
      $templateHeader.find('[data-period='+settings.period+']').addClass('active')
      $templateHeader.find('[data-type='+settings.view+']').addClass('active')

      # verify the settings values to render the proper views
      if settings.view is 'calendar'
        if settings.period is 'yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarYearly
          buildDates()
        if settings.period is 'monthly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarMonthly
        if settings.period is 'half-yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarHalfYearly
          buildDates()
        if settings.period is 'quarterly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarQuarterly
          buildDates()
      if settings.view is 'list'
        if settings.period is 'yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateListYearly
          instantiateDatatables settings.period
        if settings.period is 'monthly'
          $templateHeader.find('.yr-calendar-spot').append $templateListMonthly
          instantiateDatatables settings.period
        if settings.period is 'half-yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateListHalfYearly
          instantiateDatatables settings.period
        if settings.period is 'quarterly'
          $templateHeader.find('.yr-calendar-spot').append $templateListQuarterly
          instantiateDatatables settings.period

    buildDates = ()=>
      if viewMode is 'quarterly'
        quarter = moment().quarter()
        months = listMonths.slice (quarter - 1)*3,quarter*3
        buildDatesTemplate(months)
        return

      if viewMode is 'half-yearly'
        quarter = moment().quarter()
        half = if quarter <= 2 then 1 else 2
        months = listMonths.slice (half - 1)*6,half*6
        buildDatesTemplate(months)
        return

      if viewMode is 'yearly'
        months = listMonths
        buildDatesTemplate months

    buildDatesTemplate = (list)=>
      $(".header-#{viewMode}").empty()
      for month in list
        $(".header-#{viewMode}").append "<div class='dyn month-item-header-list #{viewMode}'>#{month}</div>"
      return
        
    createSelect = ()=>
      curYear   = moment().year()
      prevYear  = curYear - settings.gapYears
      nextYear  = curYear + settings.gapYears + 1

      listPrevYears = _.range(prevYear,curYear)
      listNextYears = _.range(curYear+1,nextYear)
      $.each listPrevYears, (i, item)->
        $('#year-select').append($('<option>', {value: item, text: item}))
      $('#year-select').append($('<option>', {value: curYear, text: curYear, selected: true}))
      $.each listNextYears, (i, item)->
        $('#year-select').append($('<option>', {value: item, text: item}))

    # IF YOU WANT TO CHANGE DATATABLES CONFIGS , YOU MUST TO ADJUST IT BELOW
    instantiateDatatables = (period)=>
      options = {
        sort: false
        data: settings.data
        retrieve: true
        bFilter: false
        bSearch: false
        bPaginate: false
        columns: [
          { title: 'Nome',                  data: 'name'}
          { title: 'Início',                data: 'begin'}
          { title: 'Término',               data: 'end'}
          { title: 'Projeto Institucional', data: 'institutional'}
          { title: 'Multilinguagem' ,       data: 'multilanguage'}
          { title: 'Atividades',            data: 'activities'}
          { title: 'Status',                data: 'status'}
        ]
      }
    
      $('#list-'+period).DataTable(options)

    instantiateFullcalendar = ()->
      $('.month-calendar').fullCalendar({
        header: false
      })
      return
    verifyYear = (direction)->

      validYear = yes

      numYear = parseInt $('#year-select > option:selected').html()

      if viewMode is 'monthly'

        if $('.month-item-header-list').html() is 'janeiro' and numYear is minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if $('.month-item-header-list').html() is 'dezembro' and numYear is maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      if viewMode is 'quarterly'

        if $('.header-quarterly').children().first().html() is 'janeiro' and numYear is minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if $('.header-quarterly').children().first().html() is 'outubro' and numYear is maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      if viewMode is 'half-yearly'
        if $('.header-half-yearly').children().first().html() is 'janeiro' and numYear is minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if $('.header-half-yearly').children().first().html() is 'julho' and numYear is maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      if viewMode is 'yearly'
        if numYear is minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if numYear is maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      return validYear

    adjustSelect = (month, direction)=>
      min       = 0
      max       = 11
      index     = $('#year-select')[0].selectedIndex
      totOpts   = $('#year-select option').length
      firstOpt  = $('#year-select option').first().html()
      lastOpt   = $('#year-select option').last().html()

      if viewMode is 'monthly'
      
        if month > max
          index = index + 1
          $('#year-select')[0].selectedIndex = index

        if month < min
          index = index - 1
          $('#year-select')[0].selectedIndex = index

      if viewMode is 'quarterly'
        # console.log month
        if direction is 'prev' and month is 6
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex - 1
        if direction is 'next' and month is 3
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex + 1

      if viewMode is 'half-yearly'
        if direction is 'prev' and month is 12
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex - 1
        if direction is 'next' and month is 0
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex + 1

      return

    navigateBetweenDates = (direction)=>
      # for month view
      if viewMode is 'monthly'

        if verifyYear(direction)

          if direction is 'prev'

            month = $('.month-item-header-list').html()
            intMonth = parseInt moment().locale('pt-br').month(month).format('MM') - 1
            prevMonth = intMonth - 1
            stringMonth = moment().locale('pt-br').month(prevMonth).format('MMMM')
            $('.month-item-header-list').html(stringMonth)
            adjustSelect prevMonth, direction
            $('.next').get(0).disabled = false
            $('.month-calendar').fullCalendar('prev')

          if direction is 'next'
            
            month = $('.month-item-header-list').html()
            intMonth = parseInt(moment().locale('pt-br').month(month).format('MM')) - 1
            nextMonth = intMonth + 1
            stringMonth = moment().locale('pt-br').month(nextMonth).format('MMMM')
            $('.month-item-header-list').html(stringMonth)
            adjustSelect nextMonth, direction
            $('.prev').get(0).disabled = false
            $('.month-calendar').fullCalendar('next')

      if viewMode is 'quarterly'

        if verifyYear direction

          if direction is 'prev'
            $('.next').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-quarterly').children().first().html()).quarter()
            pos = firstMonthOfQuarter - 1
            if pos < 1
              pos = 4
            months = listMonths.slice (pos - 1)*3,pos*3
            buildDatesTemplate(months)
            month = $('.header-quarterly').children().first().html()
            intMonth = parseInt moment().locale('pt-br').month(month).format('MM') - 1
            prevMonth = intMonth - 3
            adjustSelect prevMonth, direction

          if direction is 'next'
            $('.prev').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-quarterly').children().first().html()).quarter()
            pos = firstMonthOfQuarter + 1
            if pos > 4
              pos = 1
            months = listMonths.slice (pos - 1)*3,pos*3
            buildDatesTemplate(months)
            month = $('.header-quarterly').children().first().html()
            intMonth = parseInt(moment().locale('pt-br').month(month).format('MM')) - 1
            nextMonth = intMonth + 3
            adjustSelect nextMonth,direction
      if viewMode is 'half-yearly'

        if verifyYear direction

          if direction is 'prev'

            $('.next').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-half-yearly').children().first().html()).quarter()
            half = if firstMonthOfQuarter <= 2 then 2 else 1
            months = listMonths.slice (half - 1)*6,half*6
            buildDatesTemplate(months)
            month = $('.header-half-yearly').children().first().html()
            intMonth = parseInt(moment().locale('pt-br').month(month).format('MM')) - 1
            nextMonth = intMonth + 6
            adjustSelect nextMonth,direction

          if direction is 'next'

            $('.prev').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-half-yearly').children().first().html()).quarter()
            half = if firstMonthOfQuarter <= 2 then 2 else 1
            months = listMonths.slice (half - 1)*6,half*6
            buildDatesTemplate(months)
            month = $('.header-half-yearly').children().first().html()
            intMonth = parseInt moment().locale('pt-br').month(month).format('MM') - 1
            prevMonth = intMonth
            adjustSelect prevMonth, direction

    # changes the view and re-render the proper template for each view
    renderView = (d)=>
      if d.data().control is 'view'

        $templateHeader.find('.t-view').removeClass 'active'
        period  = $templateHeader.find('.btn-yr-calendar.active').data('period')
        viewMode = period
        $(this.prevObject[0].activeElement).addClass 'active'

        if d.data().control is 'view' and d.data('type') is 'calendar'
          if period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarYearly
            buildDates()
            return
          if period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarHalfYearly
            buildDates()
            return
          if period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarQuarterly
            buildDates()
            return
          if period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarMonthly
            instantiateFullcalendar()
            return
          return
          
        if d.data().control is 'view' and d.data('type') is 'list'
          if period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListYearly
            instantiateDatatables period
            return
          if period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListHalfYearly
            instantiateDatatables period
            return
          if period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListQuarterly
            instantiateDatatables period
            return
          if period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListMonthly
            instantiateDatatables period
            return
          return

      if d.data().control is 'period'

        $templateHeader.find('.btn-yr-calendar').removeClass 'active'
        $(this.prevObject[0].activeElement).addClass 'active'

        view = $templateHeader.find('#yr-calendar-period-buttons .active').data().type
        viewMode = d.data().period
        if view is 'calendar'
          if d.data().period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarYearly
            buildDates()
          if d.data().period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarHalfYearly
            buildDates()
          if d.data().period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarQuarterly
            buildDates()
          if d.data().period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarMonthly
            instantiateFullcalendar()
        if view is 'list'
          if d.data().period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListYearly
            instantiateDatatables d.data().period
          if d.data().period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListHalfYearly
            instantiateDatatables d.data().period
          if d.data().period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListQuarterly
            instantiateDatatables d.data().period
          if d.data().period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListMonthly
            instantiateDatatables d.data().period


    # binds button click
    listeners = () =>
      $templateHeader.find('button').click ()->
        d = $(@)
        renderView d
        return
      $templateHeader.find('.nav-dates').click ()->
        b = $(@)
        navigateBetweenDates b.data().direction
        return

      return

    # init the plugin
    init = ->
      cacheDom()
      buildTemplate()
      buildDates()
      instantiateDatatables()
      instantiateFullcalendar()
      listeners()
      createSelect()

    init()

    this
) jQuery