#create and input with a label with boostrap style is prepare for updating the parent state
#@props.label: the message to display in the label if @props.label is null no label will be display
#@props.name: the name of the input this will be also the id of the input and more import
#             will use this name for updating the parent state CAN'T BE NULL
#@props.value: a start value so we can init the component can be null
#function @props.changed: a function that notify parent of the input changed is a two parameter function
#                         first param is the name of the input and second parameter is the new value of the input
#bool @props.disabled: a bool so you can disable the input for changing
@LabelInput = React.createClass
  changed: (e) ->
    @props.changed  e.target.name,e.target.value
  render: ->
    React.DOM.div
      className: 'form-group'
      if @props.label
        React.DOM.label
          className: 'control-label'
          @props.label
      React.DOM.input
        disabled: @props.disabled
        type: 'text'
        className: 'form-control'
        placeholder: @props.placeholder
        name: @props.name
        id: @props.name
        value: @props.value
        onChange: @changed
