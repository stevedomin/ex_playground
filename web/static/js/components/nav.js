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
          <ul className="nav navbar-nav">
            <li>
              <button onClick={this.props.onRun} className="btn btn-default navbar-btn">Run</button>
            </li>
            <li>
              <button onClick={this.props.onShare} className="btn btn-default navbar-btn">Share</button>
            </li>
            <li>
              <button onClick={this.props.onEmbed} className="btn btn-default navbar-btn">Embed</button>
            </li>
          </ul>
          { this.props.showSharer ?
              <Sharer shareURL={this.props.shareURL}
                      embedCode={this.props.embedCode}
                      showEmbedCode={this.props.showEmbedCode}/>
              : null }
        </div>
      </nav>
    );
  }
};

Nav.propTypes = {
  onRun: React.PropTypes.func,
  onShare: React.PropTypes.func,
  onEmbed: React.PropTypes.func,
  shareURL: React.PropTypes.string,
  embedCode: React.PropTypes.string,
  showSharer: React.PropTypes.bool,
  showEmbedCode: React.PropTypes.bool
};
