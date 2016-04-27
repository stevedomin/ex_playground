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
        <li className="nav-item">
          <button onClick={this.props.onShare} className="btn btn-secondary navbar-btn">Share</button>
        </li>
      );
      embedButton = (
        <li className="nav-item">
          <button onClick={this.props.onEmbed} className="btn btn-secondary navbar-btn">Embed</button>
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
        <li className="nav-item">
          <button onClick={this.props.onAbout} className="btn btn-secondary navbar-btn">About</button>
        </li>
      );
    }

    return (
      <nav className="navbar navbar-light bg-faded navbar-fixed-top">
        <button className="navbar-toggler hidden-sm-up" type="button" data-toggle="collapse" data-target="#navbar-header" aria-controls="navbar-header">
          &#9776;
        </button>
        <div className="collapse navbar-toggleable-xs" id="navbar-header">
          <div className="nav-header">
            <img className="navbar__elixir-drop" src="/images/elixir-drop.png"/>
            <span className="navbar-brand">Playground</span>
          </div>
          <ul className="nav navbar-nav">
            { about }
            { shareButton }
            { embedButton }
          </ul>
          { sharer }
        </div>
      </nav>
    );
  }
};

Nav.propTypes = {
  onShare: React.PropTypes.func,
  onEmbed: React.PropTypes.func,
  shareURL: React.PropTypes.string,
  embedCode: React.PropTypes.string,
  showSharer: React.PropTypes.bool,
  showEmbedCode: React.PropTypes.bool
};
