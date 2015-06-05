import React from 'bower_components/react/react-with-addons'
import CodeMirror from 'bower_components/codemirror/lib/codemirror'

import 'web/static/js/codemirror/elixir-mode'

var IS_MOBILE = typeof navigator === 'undefined' || (
  navigator.userAgent.match(/Android/i)
    || navigator.userAgent.match(/webOS/i)
    || navigator.userAgent.match(/iPhone/i)
    || navigator.userAgent.match(/iPad/i)
    || navigator.userAgent.match(/iPod/i)
    || navigator.userAgent.match(/BlackBerry/i)
    || navigator.userAgent.match(/Windows Phone/i)
);

export default class CodeMirrorEditor extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isControlled: this.props.value != null};
  }

  componentDidMount() {
    if (this.props.forceTextArea || IS_MOBILE) {
      return; // Return early if textarea
    }
    this.editor = CodeMirror.fromTextArea(this.refs.editor.getDOMNode(), this.props);
    this.editor.on('change', this.handleChange.bind(this));
  }

  componentDidUpdate() {
    if (this.editor) {
      if (this.props.value != null) {
        if (this.editor.getValue() !== this.props.value) {
          this.editor.setValue(this.props.value);
        }
      }
    }
  }

  handleChange() {
    if (this.editor) {
      var value = this.editor.getValue();
      if (value !== this.props.value) {
        this.props.onChange && this.props.onChange({target: {value: value}});
        if (this.editor.getValue() !== this.props.value) {
          if (this.state.isControlled) {
            this.editor.setValue(this.props.value);
          } else {
            this.props.value = value;
          }
        }
      }
    }
  }

  render() {
    var textarea = React.createElement('textarea', {
      ref: 'editor',
      defaultValue: this.props.defaultValue,
      value: this.props.value,
      readOnly: this.props.readOnly,
      onChange: this.props.onChange,
      style: this.props.textAreaStyle,
      className: this.props.textAreaClassName || this.props.textAreaClass,
    });
    return React.createElement('div', {className: this.props.className}, textarea);
  }
};

CodeMirrorEditor.propTypes = {
  className: React.PropTypes.string ,
  style: React.PropTypes.object,
  onChange: React.PropTypes.func,
  value: React.PropTypes.string,
  defaultValue: React.PropTypes.string,
};
