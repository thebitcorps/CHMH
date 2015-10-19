@ElementCRUD = React.createClass
  getInitialState: ->
    edit: false
    element: @props.element
    #refactor this so we could remove name and description because they come in element
    name: @props.element.name
    description: @props.element.description
  deleteElement: ->
    respond = confirm('Desea borrar este procedimiento')
    return unless respond

    that = @
    $.ajax
        method: 'DELETE'
        url: "/#{@props.parentName}/#{ @props.element.id }"
        dataType: 'JSON'
        success:  (data) ->
          that.props.handleDeleteElement that.state.element
        error: (XMLHttpRequest, textStatus, errorThrown) ->
          alert textStatus + ' ' + errorThrown
  handleSubmit: ->
    that = @
    $.ajax
      method: 'PUT'
      url: "/#{@props.parentName}/#{ @props.element.id }"
      dataType: 'JSON'
      data: {"#{@props.modelNameSingular}": {name: @state.name, description: @state.description,area_id: @props.element.area_id}}
      success:  (data) ->
        alert 'success'
        that.setState edit: false
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        alert textStatus + ' ' + errorThrown
  handleToggle: ->
    @setState  edit: !@state.edit, name: @props.element.name,description: @props.element.description
  handleInputChange: (name,value)->
    @setState "#{name}": value
  valid: ->
    @state.name && @state.description
  render: ->
    unless @state.edit
      React.DOM.tr null,
        React.DOM.td null,
          React.DOM.a {href: "/#{@props.parentName}/#{@props.element.id}/"},@state.name
        React.DOM.td null,
          @state.description
        React.DOM.td null,
          React.DOM.div
            className: 'btn-group'
            React.DOM.a {className: 'btn btn-warning', onClick: @handleToggle }, 'Editar'
            React.DOM.a {className: 'btn btn-danger', onClick: @deleteElement }, 'Eliminar'
    else
      React.DOM.tr null,
        React.DOM.td null,
          React.createElement LabelInput, name: 'name',value: @state.name,changed: @handleInputChange,placeholder: 'Nombre'
        React.DOM.td null,
          React.createElement LabelInput, name: 'description',value: @state.description,changed: @handleInputChange,placeholder: 'Descripcion'
        React.DOM.td null,
          React.DOM.div
            className: 'btn-group'
            React.DOM.a {className: 'btn btn-primary', onClick: @handleSubmit,disabled: !@valid() }, 'Guardar'
            React.DOM.a {className: 'btn btn-default', onClick: @handleToggle }, 'Cancelar'
