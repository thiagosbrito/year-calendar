# (($)->
	
# 	CUR_YEAR 			= moment().year()
# 	CUR_MONTH 		= moment().month()
# 	LIST_MONTHS 	= moment.months()
# 	CUR_QUARTER 	= moment().quarter() 

# 	brtCalendar = {
# 		initialize: ()->
# 			_(@settings).extend $.fn.brtCalendar.defaults,options
# 			@viewMode 				= settings.period
# 			@minYear 					= CUR_YEAR - settings.gapYears
# 			@maxYear 					= CUR_YEAR + settings.gapYears
# 			@selectedYear 		= CUR_YEAR
# 			@selectedMonth 		= CUR_MONTH
# 			$selectedQuarter 	= CUR_QUARTER

# 		  @render()

# 	  render: ()->
# 			@cacheDom()
# 			@buildTemplate()
# 			@buildDates()
# 			@createSelect()
# 			@instantiateDatatables()
# 			@instantiateFullcalendar()
# 			@listeners()

# 	  cacheDom: ()=>
# 	  	@DOMElements = 
# 	      $templateHeader             : 	$ templates['header']
# 	      $templateCalendarYearly     : 	$ templates['calendar-yearly']
# 	      $templateCalendarHalfYearly : 	$ templates['calendar-half-yearly']
# 	      $templateCalendarQuarterly  : 	$ templates['calendar-quarterly']
# 	      $templateCalendarMonthly    : 	$ templates['calendar-monthly']
# 	      $templateListYearly         : 	$ templates['list-yearly']
# 	      $templateListHalfYearly     : 	$ templates['list-half-yearly']
# 	      $templateListQuarterly      : 	$ templates['list-quarterly']
# 	      $templateListMonthly        : 	$ templates['list-monthly']

#     buildTemplate: ()->
#     	$(@).append $templateHeader

      
#       # remove active class for all buttons
#       $templateHeader.find('.btn-yr-calendar').removeClass 'active'
#       $templateHeader.find('.t-view').removeClass 'active'

#       # set active the setting comming from plugin instatiate 
#       $templateHeader.find('[data-period='+settings.period+']').addClass('active')
#       $templateHeader.find('[data-type='+settings.view+']').addClass('active')

#       # verify the settings values to render the proper view      
#       if settings.view is 'calendar'
#       	switch settings.period
#       		when 'yearly'
# 	          $templateHeader.find('.yr-calendar-spot').append $templateCalendarYearly
# 	          @buildDates()
#         	when 'monthly'
# 	          $templateHeader.find('.yr-calendar-spot').append $templateCalendarMonthly
#           when 'half-yearly'
#           	$templateHeader.find('.yr-calendar-spot').append $templateCalendarHalfYearly
# 						@buildDates()

#         	when 'quarterly'
# 	          $templateHeader.find('.yr-calendar-spot').append $templateCalendarQuarterly
# 	          @buildDates()
      
#       if settings.view is 'list'
#         switch settings.period
# 	        when 'yearly'
# 	          $templateHeader.find('.yr-calendar-spot').append $templateListYearly
# 	          @instantiateDatatables settings.period
# 	        when 'monthly'
# 	          $templateHeader.find('.yr-calendar-spot').append $templateListMonthly
# 	          @instantiateDatatables settings.period
# 	        when 'half-yearly'
# 	          $templateHeader.find('.yr-calendar-spot').append $templateListHalfYearly
# 	          @instantiateDatatables settings.period
# 	        when 'quarterly'
# 	          $templateHeader.find('.yr-calendar-spot').append $templateListQuarterly
# 	          @instantiateDatatables settings.period
		
# 		buildDates: ()=>
# 			switch viewMode

#       	when'quarterly'
# 	        quarter = moment().quarter()
# 	        months = LIST_MONTHS.slice (quarter - 1)*3,quarter*3
# 	        buildDatesTemplate months

#       	when 'half-yearly'
# 	        quarter = moment().quarter()
# 	        half = if quarter <= 2 then 1 else 2
#         	months = LIST_MONTHS.slice (half - 1)*6,half*6
#         	buildDatesTemplate months

#       	when 'yearly'
# 	        months = listMonths
# 	        buildDatesTemplate months

#     buildDatesTemplate: (list)=>
#       $(".header-#{viewMode}").empty()
#       for month in list
#         $(".header-#{viewMode}").append "<div class='dyn month-item-header-list #{viewMode}'>#{month}</div>"
#       return

#     createSelect: ()=>
#       optionsSelect = []
#       listYears = _.range(CUR_YEAR - settings.gapYears,CUR_YEAR + settings.gapYears + 1)
#       $.each listYears, (i, item)->
#       	selected = "selected" if item is CUR_YEAR
#     		option 	= "<option value=#{item} #{selected}>#{item}</option>"
#       	optionsSelect.push option
#     	$('#year-select').append(optionsSelect.join(""))


#   	# Ext plugins
#   	instantiateDatatables: (period)=>
#       options = {
#         sort: false
#         data: settings.data
#         retrieve: true
#         bFilter: false
#         bSearch: false
#         bPaginate: false
#         columns: [
#           { title: 'Nome',                  data: 'nome'}
#           { title: 'Início',                data: 'start'}
#           { title: 'Término',               data: 'end'}
#           { title: 'Projeto Institucional', data: 'institucional'}
#           { title: 'Multilinguagem' ,       data: 'linguagens'}
#           { title: 'Atividades',            data: 'atividades'}
#           { title: 'Status',                data: 'status'}
#         ]
#       }
#       $("#list-#{period}").DataTable(options)

#     # adjustPopover: ()->

#     createPopover: (calEvent, event)->
#     	$("#evento#{calEvent.id}").popover('show')
#       $('.fc-row').css('z-index',-1)
#       $popoverEl = $('.popover')
#       $eventEl   = $ event.target
#       left = event.pageX - ($popoverEl.width() / 2)
#       if left >= 940
#         left = 920
#       else if left <= 220
#         left = 240

#       topEventEl = $eventEl.offset().top
#       top = topEventEl - $popoverEl.height()

#       if top < 200
#         $("#evento#{calEvent.id}").siblings('.popover').removeClass('right')
#         $("#evento#{calEvent.id}").siblings('.popover').addClass('bottom')
#         $popoverEl.offset
#           left : left
#           top  : top + 140
#       else
#         $("#evento#{calEvent.id}").siblings('.popover').removeClass('right')
#         $("#evento#{calEvent.id}").siblings('.popover').addClass('top')
#         $popoverEl.offset
#           left : left
#           top  : top

#       popoverOpts = 
#         container: '.fc-view-container'
#         html: true
#         title: calEvent.title

#       $("#evento#{calEvent.id}").popover(popoverOpts)

#     removePopover: ->
#     	$("#evento#{ev.id}").popover('destroy')
#       $('.fc-row').css('z-index',1)

#     createFullCalendar: ->
#       $('.month-calendar').fullCalendar({
#         header: false,
#         events: settings.data
#         eventMouseover: (calEvent, event, view)->
#         	createPopover calEvent,event
#         eventMouseout: (ev,el,co)->
#         	removePopover()
#         eventRender: (ev, el)->
#           el.attr "data-toogle","popover"
#           el.attr "data-content","#{ev.descricao}"
#           el.attr "data-original-title","#{ev.title}"
#           el.attr "id","evento#{ev.id}"
#       })
#     verifyYear: (direction)->
#       validYear = yes
#       numYear = @selectedYear
#       switch @viewMode

#       	when 'monthly'
# 	        if $('.month-item-header-list').html() is 'janeiro' and numYear <= minYear and direction is 'prev'
# 	          $('.prev').get(0).disabled = true
# 	          return validYear = no

# 	        if $('.month-item-header-list').html() is 'dezembro' and numYear >= maxYear and direction is 'next'
# 	          $('.next').get(0).disabled = true
# 	          return validYear = no

#       	when 'quarterly'

# 	        if $('.header-quarterly').children().first().html() is 'janeiro' and numYear <= minYear and direction is 'prev'
# 	          $('.prev').get(0).disabled = true
# 	          return validYear = no

# 	        if $('.header-quarterly').children().first().html() is 'outubro' and numYear >= maxYear and direction is 'next'
# 	          $('.next').get(0).disabled = true
# 	          return validYear = no

#       	when 'half-yearly'
# 	        if $('.header-half-yearly').children().first().html() is 'janeiro' and numYear <= minYear and direction is 'prev'
# 	          $('.prev').get(0).disabled = true
# 	          return validYear = no

# 	        if $('.header-half-yearly').children().first().html() is 'julho' and numYear >= maxYear and direction is 'next'
# 	          $('.next').get(0).disabled = true
# 	          return validYear = no

# 	      when 'yearly'
# 	        if numYear <= minYear and direction is 'prev'
# 	          $('.prev').get(0).disabled = true
# 	          return validYear = no

# 	        if numYear >= maxYear and direction is 'next'
# 	          $('.next').get(0).disabled = true
# 	          return validYear = no

#       return validYear

#     adjustSelect: (month, direction)=>
#       min       	= 0
#       max       	= 11
#       $yearSelect = $('#year-select')

#       switch @viewMode

#       	when 'monthly'
# 	        if month < min
# 	          $yearSelect.val(--@selectedYear)
# 	        if month > max
# 	          $yearSelect.val(++@selectedYear)

#         when 'quarterly'
# 	        if direction is 'prev' and month is 6
# 	          $yearSelect.val(--@selectedYear)
# 	        if direction is 'next' and month is 3
# 	          $yearSelect.val(++@selectedYear)

# 	      when 'half-yearly'
# 	        if direction is 'prev' and month is 12
# 	          $yearSelect.val(--@selectedYear)
# 	        if direction is 'next' and month is 0
# 	          $yearSelect.val(++@selectedYear)

# 	      when 'yearly'
# 	        if direction is 'prev'
# 	          $yearSelect.val(--@selectedYear)
# 	        else
# 	          $yearSelect.val(++@selectedYear)
#     navigateBetweenDates: (direction)=>
      
#       switch @viewMode

# 	      when 'monthly'

# 	        if verifyYear direction

# 	          if direction is 'prev'
# 	            prevMonth = --@selectedMonth
# 	            stringMonth = LIST_MONTHS[prevMonth]
# 	            $('.month-item-header-list').html(stringMonth)
# 	            adjustSelect prevMonth, direction
# 	            $('.next').prop('disabled',no)
# 	            $('.month-calendar').fullCalendar('prev')

# 	          if direction is 'next'
	            
# 	            nextMonth = ++@selectedMonth
# 	            stringMonth = LIST_MONTHS[nextMonth]
# 	            $('.month-item-header-list').html stringMonth 
# 	            adjustSelect nextMonth, direction
# 	            $('.prev').prop('disabled',no)
# 	            $('.month-calendar').fullCalendar('next')

# 	      when 'quarterly'

# 	        if verifyYear direction

# 	          if direction is 'prev'

# 	            $('.next').prop('disabled',no)
# 	            pos = --@selectedQuarter
# 	            if pos < 1
# 	              pos = 4
# 	            months = LIST_MONTHS.slice (pos - 1)*3,pos*3
# 	            buildDatesTemplate months
# 	            prevMonth = @selectedMonth -= 3
# 	            adjustSelect prevMonth, direction

# 	          if direction is 'next'

# 	            $('.prev').prop('disabled',no)
# 	            pos = ++@selectedQuarter
# 	            if pos > 4
# 	              pos = 1
# 	            months = LIST_MONTHS.slice (pos - 1)*3,pos*3
# 	            buildDatesTemplate months
# 	            nextMonth = @selectedMonth += 3
# 	            adjustSelect nextMonth,direction

# 	      when 'half-yearly'
# 	        if verifyYear direction
# 	          if direction is 'prev'

# 	            $('.next').prop('disabled',no)
	            
# 	            half = if @selectedQuarter <= 2 then 2 else 1
# 	            months = LIST_MONTHS.slice (half - 1)*6,half*6
# 	            buildDatesTemplate months
# 	            nextMonth = @selectedMonth + 6
# 	            adjustSelect nextMonth,direction

# 	          if direction is 'next'

# 	            $('.prev').prop('disabled',no)
	            
# 	            months = LIST_MONTHS.slice (half - 1)*6,half*6
# 	            buildDatesTemplate months
# 	            prevMonth = @selectedMonth
# 	            adjustSelect prevMonth, direction

# 	      when 'yearly'
# 	        if verifyYear direction
# 	          if direction is 'prev'
# 	            $('.next').prop('disabled',no)
# 	          else
# 	            $('.prev').prop('disabled',no)
# 	          adjustSelect null,direction
#     renderView: (d)->
      
      
#       $('.next').prop('disabled',no)
#       $('.prev').prop('disabled',no)
      
#       $control = d.data().control

#       switch $control

# 	      when 'view'

# 	        $templateHeader.find('.t-view').removeClass 'active'
# 	        period  = $templateHeader.find('.btn-yr-calendar.active').data().period
# 	        @viewMode = period
	        
# 	        $(this.prevObject[0].activeElement).addClass 'active'

# 	        if d.data().control is 'view' and d.data('type') is 'calendar'

# 	          if period is 'yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarYearly
# 	            @buildDates()
# 	            return

# 	          if period is 'half-yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarHalfYearly
# 	            @buildDates()
# 	            return

# 	          if period is 'quarterly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarQuarterly
# 	            @buildDates()
# 	            return

# 	          if period is 'monthly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarMonthly
# 	            instantiateFullcalendar()
# 	            return

# 	          return
	          
# 	        if d.data().control is 'view' and d.data('type') is 'list'
# 	          if period is 'yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListYearly
# 	            @instantiateDatatables period
# 	            return
# 	          if period is 'half-yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListHalfYearly
# 	            @instantiateDatatables period
# 	            return
# 	          if period is 'quarterly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListQuarterly
# 	            @instantiateDatatables period
# 	            return
# 	          if period is 'monthly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListMonthly
# 	            @instantiateDatatables period
# 	            return
# 	          return

# 	      when 'period'

# 	        $templateHeader.find('.btn-yr-calendar').removeClass 'active'
# 	        $(this.prevObject[0].activeElement).addClass 'active'

# 	        view = $templateHeader.find('#yr-calendar-period-buttons .active').data().type
# 	        @viewMode = d.data().period
# 	        if view is 'calendar'
# 	          if d.data().period is 'yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarYearly
# 	            @buildDates()
# 	          if d.data().period is 'half-yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarHalfYearly
# 	            @buildDates()
# 	          if d.data().period is 'quarterly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarQuarterly
# 	            @buildDates()
# 	          if d.data().period is 'monthly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarMonthly
# 	            instantiateFullcalendar()
# 	        if view is 'list'
# 	          if d.data().period is 'yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListYearly
# 	            @instantiateDatatables d.data().period
# 	          if d.data().period is 'half-yearly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListHalfYearly
# 	            @instantiateDatatables d.data().period
# 	          if d.data().period is 'quarterly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListQuarterly
# 	            @instantiateDatatables d.data().period
# 	          if d.data().period is 'monthly'
# 	            $templateHeader.find('.yr-calendar-spot').empty().append $templateListMonthly
# 	            @instantiateDatatables d.data().period

#     listeners: () =>
#       $templateHeader.find('button').click ()->
#         d = $(@)
#         if !d.data().direction
#           renderView d
#         return
#       $templateHeader.find('.nav-dates').click ()->
#         b = $(@)
#         navigateBetweenDates b.data().direction
#         return

#       return

# 	}

# 	$.fn.brtCalendar = (options) ->
# 		brtCalendar.initialize options,this

# 	$.fn.brtCalendar.defaults = {
# 		data: null
#     view: 'calendar'
#     period: 'yearly'
#     gapYears: 20
# 	}



# )(jQuery)