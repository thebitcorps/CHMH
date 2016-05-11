#An select field with label that update the parent state with the given aame and the option selected
#default props
#@props.options: it should be an array of hashes [{display , value},{display , value}] defaull[]
#@props.name: the name of the select input also this will be the id
#@props.label: string to display on the label if null no label will display
#@props.defaultValue: the initial value for the select could be null
#boolean @props.multiple: make the select mulple wirh boostrap atribute
#function @props.onChanged: function with one params that return the value of the select whenever it changes
@LabelSelect = React.createClass
  getDefaultProps: ->
    options: []
    multiple: false
  changed: (e) ->
    @props.onChanged @props.name,e.target.value
  render: ->
    React.DOM.div
      className: 'form-group'
      if @props.label
        React.DOM.label
          className: 'control-label'
          @props.label
      React.DOM.select
        className: 'form-control'
        name: @props.name
        id: @props.name
        onChange: @changed
        multiple: @props.multiple
        for option,index in @props.options
          React.DOM.option
          #its okay to use the index here because this opton is not dinamic now
            key: index
            value: option.value
            option.display