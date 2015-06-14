import React from 'bower_components/react/react-with-addons'
import CodeMirrorEditor from './codemirror-editor'

export default class Console extends React.Component {
  render() {
    return (
      <CodeMirrorEditor
        className={this.props.className}
        lineNumbers={false}
        mode="plain"
        readOnly={true}
        value={this.props.output}
      />
    );
  }
}

Console.propTypes = {
  className: React.PropTypes.string,
  value: React.PropTypes.string
}
