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
    errors: []
    minutes: 0
    notes: ''
    messageSurgery: 'Seleccione primero un procedimiento'
  createOptions: (objects,displayObjectName,valueObjectName) ->
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
        that.setState {tasks: that.createOptions(data, 'name','id'),selectedTasks: [],messageSurgery: 'Seleccione actividades de abajo',surgery_id: value }
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
        break
  textAreaChange: (e) ->
    @setState "#{e.target.name}": e.target.value
  removeSelectedTask: (name,value) ->
    for task,index in @state.selectedTasks
      if task.value == parseInt(value,10)
        tasks = @state.tasks.slice()
        tasks.push task
        selectedTask = @state.selectedTasks.slice()
        selectedTask.splice index,1
        @setState {tasks: tasks,selectedTasks: selectedTask}
        break
  valid: ->
    @state.hours && @state.folio && @state.donedate && @state.surgery_id
  submitProcedure: (e)->
    e.preventDefault()
    that = @
    tasks_ids = []
    for task in @state.selectedTasks
      tasks_ids.push task.value
    $.ajax
      data:
        procedure: {folio: @state.folio,notes: @state.notes,surgery_id: @state.surgery_id,donedate: @state.donedate}
        hou: @state.hours
        min: @state.min
        task_procedure_ids: tasks_ids


      url: '/procedures'
      type: 'POST'
      dataType: 'JSON'
      success:  (data) ->
        window.location.assign('/procedures/' + data.id)
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return

  render: ->
    React.DOM.div
      className: 'procedure-form'
      React.createElement ErrorBox, errorsArray: @state.errors
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
      React.DOM.div
        className: 'panel panel-primary'
        React.DOM.div
          className: 'panel panel-heading'
          React.DOM.label
            className: 'form-label'
            'Actividades dentro del procedimiento: '
        React.DOM.div
          className: 'panel panel-body'
          React.DOM.h4 null,
            if @state.selectedTasks.length == 0
              React.DOM.span
                className: 'label label-default'
                @state.messageSurgery
            for selectedTask in @state.selectedTasks
              React.createElement Task , task: selectedTask,key: selectedTask.value,handleClick: @removeSelectedTask,color: 'primary'
      React.DOM.div
        className: 'panel panel-default'
        React.DOM.div
          className: 'panel panel-heading'
          React.DOM.label
            className: 'form-label'
            'Actividades dentro de la cirugia: '
        React.DOM.div
          className: 'panel panel-body'
          React.DOM.h4 null,
            if @state.tasks.length == 0
              React.DOM.span
                className: 'label label-default'
                @state.messageSurgery
            for task in @state.tasks
              React.createElement Task , task: task,key: task.value,handleClick: @taskSelected
#      React.createElement LabelSelect, name: 'task',options: @state.tasks,multiple: true,onChanged: @taskSelected
      React.DOM.label
        className: 'form-label'
        'Anotaciones'
      React.DOM.textarea
        className: 'form-control'
        name: 'notes'
        onChange: @textAreaChange
      React.DOM.br null
      React.DOM.button
        className: 'btn btn-primary'
        onClick: @submitProcedure
        disabled: !@valid()
        'Submit'