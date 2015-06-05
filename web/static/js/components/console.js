import React from 'bower_components/react/react-with-addons'
import CodeMirrorEditor from './codemirror-editor'

export default class Console extends React.Component {
  render() {
    return (
      <CodeMirrorEditor
        lineNumbers={false}
        mode="plain"
        readOnly={true}
        value={this.props.output}
      />
    );
  }
}

