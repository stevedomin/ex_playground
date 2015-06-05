import React from 'bower_components/react/react-with-addons'

export default class Nav extends React.Component {
  render() {
    return (
      <div>
        <button onClick={this.props.onRun}>Run code</button>
        <button onClick={this.props.onShare}>Share</button>
      </div>
    );
  }
};

Nav.propTypes = {
  onRun: React.PropTypes.func,
  onShare: React.PropTypes.func,
};
