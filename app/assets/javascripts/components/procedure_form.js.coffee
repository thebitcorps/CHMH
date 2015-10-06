@ProcedureForm = React.createClass
  getDefaultProps: ->
    #create options offrom 0 to lastnumber we generate function here because
    #the instance of the react object is no already create in this callback
    createNumbersOptions = (lastNumber) ->
      numbers = []
      for i in [0..lastNumber]
        numbers.push {'display': i,'value': i}
      return numbers
    hours: createNumbersOptions(10)
    minutes: createNumbersOptions(60)
  getInitialState: ->
    #maybe we should surgeries  this at server side so we eliminate this unnecessary state and make it a prop
    surgeries: @createOptions(@props.surgeries,'name','id')
    tasks: []
    selectedTasks: []
    messageSurgery: 'Seleccione primero un procedimiento'
  createOptions: (objects,displayObjectName,valueObjectName,firstEmpty) ->
    options = [{'display': 'Seleccione una opcion...','value': ''}]
    for thing in objects
      options.push {'display': thing[displayObjectName] ,'value': thing[valueObjectName]}
    return options
  inputChange: (name,value) ->
    @setState "#{name}": value
  surgeryChange: (name,value) ->
    if value == ''
      @setState {tasks: [],selectedTasks: [],messageSurgery: 'Seleccione primero un procedimiento'}
      return
    that = @
    $.ajax
      url: '/surgeries/' + value + '/query.json'
      type: 'GET'
      dataType: 'JSON'
      success:  (data) ->
        that.setState {tasks: that.createOptions(data, 'name','id'),selectedTasks: [],messageSurgery: 'Seleccione actividades de abajo'}
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return
  taskSelected: (name,value) ->
    for task,index in @state.tasks
      if task.value == parseInt(value,10)
        selectedTask = @state.selectedTasks.slice()
        selectedTask.push task
        tasks = @state.tasks.slice()
        tasks.splice index,1
        @setState {tasks: tasks,selectedTasks: selectedTask}
        $('#task')[0].selectedIndex = 0
        break
  textAreaChange: (e) ->
    @setState "#{e.target.name}": e.target.value
  removeSelectedTask: (e)->
    alert 'caca'
  render: ->
    React.DOM.div
      className: 'procedure-form'
      React.createElement LabelInput,name: 'folio',label: 'Folio:',changed: @inputChange
      React.createElement LabelInput,name: 'donedate',label: 'Fecha de Realizacion:',changed: @inputChange
      React.DOM.label
        className: 'control-label'
        'Duración de procedimiento:'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-md-6'
          React.createElement LabelSelect, name: 'hours',label: 'Horas',options: @props.hours,onChanged: @inputChange
        React.DOM.div
          className: 'col-md-6'
          React.createElement LabelSelect, name: 'minutes',label: 'Minutos',options: @props.minutes,onChanged: @inputChange
      React.createElement LabelSelect, name: 'surgery_id',label: 'Procedimiento a participar:',options: @state.surgeries,onChanged: @surgeryChange
      React.DOM.label
        className: 'form-label'
        'Actividades dentro del procedimiento: '
      React.DOM.h4 null,
        if @state.selectedTasks.length == 0
          React.DOM.span
            className: 'label label-default'
            @state.messageSurgery
        for selectedTask in @state.selectedTasks
          React.DOM.span
            className: 'label label-primary'
            onClick: @removeSelectedTask
            selectedTask.display
      React.createElement LabelSelect, name: 'task',options: @state.tasks,multiple: true,onChanged: @taskSelected
      React.DOM.label
        className: 'form-label'
        'Anotaciones'
      React.DOM.textarea
        className: 'form-control'
        name: 'notes'
        onChange: @textAreaChange