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
    return (
      <div className={this.props.className}>
        <CodeMirror className="code-editor-pane__codemirror"
                    value={this.state.code}
                    onChange={this.props.onChange}
                    options={options} />
        <button className="btn btn-primary run-button" onClick={this.props.onRun}>
          Run
        </button>
      </div>
    );
  }
}

CodeEditor.propTypes = {
  className: React.PropTypes.string,
  onRun: React.PropTypes.func,
  code: React.PropTypes.string,
  extraKeys: React.PropTypes.object,
  onChange: React.PropTypes.func
};

