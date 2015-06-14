import React from 'bower_components/react/react-with-addons'
import CodeMirrorEditor from './codemirror-editor'

export default class CodeEditor extends React.Component {
  render() {
    return (
      <CodeMirrorEditor
        className={this.props.className}
        lineNumbers
        mode='elixir'
        extraKeys={this.props.extraKeys}
        value={this.props.code}
        onChange={this.props.onChange} />
    );
  }
}

CodeEditor.propTypes = {
  className: React.PropTypes.string,
  code: React.PropTypes.string,
  extraKeys: React.PropTypes.object,
  onChange: React.PropTypes.func,
};

