import React from 'react'
import CodeMirror from 'react-codemirror'

import '../codemirror/elixir-mode'

export default class CodeEditor extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      code: props.code,
      extraKeys: props.extraKeys
    };
  }

  render() {
    var options = {
      lineNumbers: true,
      mode: 'elixir',
      extraKeys: this.props.extraKeys
    };
    return <CodeMirror className={this.props.className}
                       value={this.state.code}
                       onChange={this.props.onChange}
                       options={options} />
  }
}

CodeEditor.propTypes = {
  className: React.PropTypes.string,
  code: React.PropTypes.string,
  extraKeys: React.PropTypes.object,
  onChange: React.PropTypes.func,
};

