# @cjsx React.DOM
# This is the alternative approach for the coffee-react transpiler

React = require 'react'

ReactComponent = React.createClass
  displayName: 'ReactComponent'
  render: ->
    <div className='css-class-name' prop1={1 + 2} flag>
      This "html" tag will get transpiled by coffee-react to be valid coffeescript function calls
    </div>

module.exports = ReactComponent
