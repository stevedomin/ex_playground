import React from 'bower_components/react/react-with-addons'

export default class Sharer extends React.Component {
  componentDidMount() {
    React.findDOMNode(this.refs.shareInput).select();
  }

  render() {
    return (
      <form className="navbar-form navbar-left navbar__sharer">
        <div className="form-group">
          <input type="text" ref="shareInput"
            className="form-control navbar__sharer__input"
            value={this.props.shareURL}
            readOnly autoFocus />
        </div>
      </form>
    );
  }
};

Sharer.propTypes = {
  shareURL: React.PropTypes.string
}
