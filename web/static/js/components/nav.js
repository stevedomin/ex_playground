import React from 'react'

import Sharer from './sharer'

var IN_IFRAME = window.self !== window.top;

export default class Nav extends React.Component {
  render() {
    var shareButton,
      embedButton,
      sharer,
      about;

    if (!IN_IFRAME) {
      shareButton = (
        <li>
          <button onClick={this.props.onShare} className="btn btn-default navbar-btn">Share</button>
        </li>
      );
      embedButton = (
        <li>
          <button onClick={this.props.onEmbed} className="btn btn-default navbar-btn">Embed</button>
        </li>
      );

      if (this.props.showSharer) {
        sharer = (
          <Sharer shareURL={this.props.shareURL}
            embedCode={this.props.embedCode}
            showEmbedCode={this.props.showEmbedCode}/>
        );
      }

      about = (
        <ul className="nav navbar-nav navbar-right">
          <li>
            <button onClick={this.props.onAbout} className="btn btn-default navbar-btn">About</button>
          </li>
        </ul>
      );
    }

    return (
      <nav className="navbar navbar-default navbar-fixed-top">
        <div className="container-fluid">
          <div className="navbar-header">
            <img className="navbar__elixir-drop" src="/images/elixir-drop.png"/>
            <a className="navbar-brand" href="/">Playground</a>
          </div>
          <ul className="nav navbar-nav">
            <li>
              <button onClick={this.props.onRun} className="btn btn-default navbar-btn">Run</button>
            </li>
            { shareButton }
            { embedButton }
          </ul>
          { sharer }
          { about }
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
