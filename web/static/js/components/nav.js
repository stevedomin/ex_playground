import React from 'bower_components/react/react-with-addons'

import Sharer from './sharer'

export default class Nav extends React.Component {
  render() {
    return (
      <nav className="navbar navbar-default navbar-fixed-top">
        <div className="container-fluid">
          <div className="navbar-header">
            <img className="navbar__elixir-drop" src="/images/elixir-drop.png"/>
            <a className="navbar-brand" href="#">Playground</a>
          </div>
          <div id="navbar" className="navbar-collapse collapse">
            <ul className="nav navbar-nav">
              <li>
                <button onClick={this.props.onRun} className="btn btn-default navbar-btn">Run</button>
              </li>
              <li>
                <button onClick={this.props.onShare} className="btn btn-default navbar-btn">Share</button>
              </li>
            </ul>
            { this.props.shareURL ? <Sharer shareURL={this.props.shareURL} /> : null }
          </div>
        </div>
      </nav>
    );
  }
};

Nav.propTypes = {
  onRun: React.PropTypes.func,
  onShare: React.PropTypes.func,
  shareURL: React.PropTypes.string
};
