import React from 'react'
import ReactDOM from 'react-dom'
import $ from 'jquery'
import 'bootstrap'

import 'phoenix_html'
import {Socket} from 'phoenix'

import About from './components/about'
import CodeEditor from './components/code-editor'
import Console from './components/console'
import Nav from './components/nav'

var SUPPORTS_HISTORY = window.history &&
  window.history.replaceState &&
  window.history.pushState;

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      channel: null,
      showAbout: false,
      output: "",
      code: $("#editor").val().trim(), // ugly, need to find something better
      extraKeys: {
        "Cmd-Enter": function(editor) {
          this.handleRunClick()
        }.bind(this)
      }
    };
  }

  componentDidMount() {
    if (SUPPORTS_HISTORY) {
      var path = window.location.pathname;
      var newState = {
        code: this.state.code
      }
      window.history.replaceState(newState, "", path);
      window.onpopstate = this.onpopstateHandler.bind(this);
    }

    this.connectAndJoin();
  }

  render() {
    return (
      <div className="app">
        <Nav onShare={this.handleShareClick.bind(this)}
          onEmbed={this.handleEmbedClick.bind(this)}
          onAbout={this.handleAboutClick.bind(this)}
          shareURL={this.state.shareURL}
          embedCode={this.state.embedCode}
          showSharer={this.state.showSharer}
          showEmbedCode={this.state.showEmbedCode} />
        <div className="container-fluid workspace">
          { this.state.showAbout ?
              <About className="about-pane"
                onClose={this.handleAboutCloseClick.bind(this)} />
              : null }
          <CodeEditor className="row code-editor-pane"
            code={this.state.code}
            extraKeys={this.state.extraKeys}
            onChange={this.handleCodeEditorChange.bind(this)}
            onRun={this.handleRunClick.bind(this)}/>
          <Console className="row console-pane"
            output={this.state.output} />
        </div>
      </div>
    );
  }

  connectAndJoin() {
    var socket = new Socket("/socket")
    socket.connect();

    var channel = socket.channel("code:stream", {});
    channel.on("output", this.handleChannelOutput.bind(this));
    channel.join().receive("ok", this.handleChannelJoined.bind(this));

    this.setState({channel: channel});
  }

  handleCodeEditorChange(e) {
    this.setState({
      code: e,
      shareURL: "",
      embedCode: "",
      showSharer: false,
      showEmbedCode: false
    });
  }

  handleRunClick() {
    if (window.sendEvent) {
      window.sendEvent("button", "click", "run-button");
    }

    var channel = this.state.channel;
    if (channel) {
      if (channel.state != "joined") {
        this.connectAndJoin();
      }
      channel.push("run", {code: this.state.code})
      this.setState({output: ""});
    }
  }

  handleChannelJoined() {
    console.log("Playground channel ready!");
  }

  handleChannelOutput(payload) {
    var output = this.state.output;

    if (payload.type == "result") {
      switch(payload.status) {
        case 0:
          output += "\nProgram exited successfully.";
          break;
        default:
          output += "\nProgram exited with errors.";
          break;
      }
    } else if (payload.type == "timeout") {
      output += "\nProgram timed out. Execution time is limited to " + payload.timeout + "ms."
    } else {
      output += payload.data;
    }

    this.setState({output: output});
  }

  handleShareClick() {
    if (window.sendEvent) {
      window.sendEvent("button", "click", "share-button");
    }
    this.setState({showEmbedCode: false});
    this.shareCode();
  }

  handleEmbedClick() {
    if (window.sendEvent) {
      window.sendEvent("button", "click", "embed-button");
    }
    this.setState({showEmbedCode: true});
    this.shareCode();
  }

  shareCode() {
    var body = {code: this.state.code};
    $.ajax({
      url: '/share',
      type: 'POST',
      data: body,
      success: this.shareCodeSuccessHandler.bind(this),
      error: this.shareCodeErrorHandler.bind(this)
    });
  }

  shareCodeSuccessHandler(data) {
    var path = "/s/" + data
    var url = window.location.origin + path;
    var embedCode = "<iframe src=\""+ url +"\" frameborder=\"0\" style=\"width: 100%; height: 100%\"></iframe>";
    this.setState({
      showSharer: true,
      shareURL: url,
      embedCode: embedCode
    });
    if (SUPPORTS_HISTORY) {
      var state = {code: this.state.code};
      window.history.pushState(state, "", path);
    }
  }

  shareCodeErrorHandler(xhr, status, err) {
    this.setState({
      showSharer: false,
      showEmbedCode: true
    });
    console.error(status, err);
  }

  onpopstateHandler(event) {
    this.setState({
      shareURL: "",
      embedCode: "",
      showSharer: false,
      showEmbedCode: false,
      code: event.state.code
    });
  }

  handleAboutClick() {
    this.setState({showAbout: !this.state.showAbout});
  }

  handleAboutCloseClick() {
    this.setState({showAbout: false});
  }
};

ReactDOM.render(<App/>, document.getElementById('app'));


