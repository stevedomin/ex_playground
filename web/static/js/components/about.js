import React from 'react'

export default class About extends React.Component {
  render() {
    return (
      <div className={this.props.className}>
        <div>
          <h4>About the Elixir Playground</h4>
          <button type="button" className="close about-pane__close"
            onClick={this.props.onClose}>
            <span>&times;</span>
          </button>
        </div>
        <p>The Elixir playground is a web application that allows you to run <a href="http://elixir-lang.org/" target="blank">Elixir</a> code online.</p>

        <p>Once you have written some Elixir code, you can get a permanent link to your snippet using the 'Share' button.</p>

        <h5>Limitations</h5>
        <ul>
          <li>You can use almost all of the standard library but some system capabilites have been dropped (networking for example).</li>
          <li>Execution time is limited to 10 seconds.</li>
          <li>CPU and Memory usage are limited.</li>
        </ul>

        <p>We will always keep the playground up to date with the latest stable version of Elixir and Erlang.<br />
        You can run <a href="/s/e2593e1760/">this program</a> to find out the exact versions.</p>

        <p>The sources are available <a href="https://github.com/stevedomin/ex_playground" target="blank">here</a>.</p>

        <p>If you have any questions or issues I'm <a href="https://twitter.com/stevedomin">@stevedomin</a> on Twitter, please get in touch.</p>
      </div>
    );
  }
}

About.propTypes = {
  className: React.PropTypes.string,
  onClose: React.PropTypes.func
};

