import React from 'bower_components/react/react-with-addons'
import CodeMirrorEditor from './codemirror-editor'

export default class CodeEditor extends React.Component {
  render() {
    return (
      <CodeMirrorEditor
        lineNumbers
        mode='elixir'
        value={this.props.code}
        onChange={this.props.onChange} />
    );
  }
}

CodeEditor.propTypes = {
  code: React.PropTypes.string,
  onChange: React.PropTypes.func,
};

