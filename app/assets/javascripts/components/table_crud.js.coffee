@TableCRUD = React.createClass
  getInitialState: ->
    list: @props.list
    errors: []

  inputChange: (name,value)->
    @setState "#{name}": value
  addNewElement: ->
    that = @
    $.ajax
      url: "/#{@props.modelNamePlural}.json"
      type: 'POST'
      dataType: 'JSON'
      data: {"#{@props.modelNameSingular}": {name: @state.name,description: @state.description, "#{@props.parentName}_id": @props.parentId}}
      success:  (data) ->
        alert
        elements = that.state.list.slice()
        elements.push(data)
        that.setState {list: elements,name: '',description: ''}
        $('#name').val('')
        $('#description').val('')

        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        window.location.hash = '#errorbox'
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return
  removeElement: (element)->
    elements = @state.list.slice()
    index = elements.indexOf element
    elements.splice index , 1
    @setState list: elements

  valid: ->
    @state.name && @state.description
  render: ->
    React.DOM.div
      className: 'todo-CRUD panel panel-default'
      React.createElement ErrorBox , errorsArray: @state.errors
      React.DOM.div
        className: 'panel panel-heading'
        React.DOM.h3 null,"#{@props.displayName} (#{@state.list.length})"
      React.DOM.table className: 'table table-hover',
        React.DOM.thead null,
          React.DOM.tr null,
            for th,index in ['Nombre', 'Descripcion','Acciones']
              React.DOM.th key: index,th
          React.DOM.tr null,
            React.DOM.th null,
              React.createElement LabelInput , name: 'name',placeholder: 'Nombre',changed: @inputChange
            React.DOM.th null,
              React.createElement LabelInput , name: 'description',placeholder: 'Descripcion',changed: @inputChange
            React.DOM.th null,
              React.DOM.a {className: 'btn btn-primary',onClick: @addNewElement,disabled: !@valid()},"Crear Nuevo"

        React.DOM.tbody null,
          for element in @state.list
            React.createElement ElementCRUD, element: element,handleDeleteElement: @removeElement, parentName: @props.modelNamePlural,modelNameSingular: @props.modelNameSingular,key: element.id


