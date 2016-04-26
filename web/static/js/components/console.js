import React from 'react'
import CodeMirror from 'react-codemirror'

export default class Console extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    var options = {
      lineNumbers: false,
      mode: "plain",
      readOnly: true
    };
    return <CodeMirror className={this.props.className}
                       onChange={this.updateCode}
                       options={options}
                       value={this.props.output} />
  }
}

Console.propTypes = {
  className: React.PropTypes.string,
  value: React.PropTypes.string
}
