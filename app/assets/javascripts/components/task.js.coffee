@Task = React.createClass
  getDefaultProps: ->
    color: 'default'
  taskClicked: ->
    @props.handleClick @props.task.display,@props.task.value
  render: ->
    React.DOM.div
      className: 'inline'
      React.DOM.span
        className: "label label-#{@props.color}"
        onClick: @taskClicked
        style: {cursor: 'pointer'}
        @props.task.display