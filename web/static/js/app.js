import React from 'bower_components/react/react-with-addons'
import $ from 'bower_components/jquery/dist/jquery'

import CodeEditor from './components/code-editor'
import Console from './components/console'
import Nav from './components/nav'

var SUPPORTS_HISTORY = window.history &&
  window.history.replaceState &&
  window.history.pushState

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
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
  }

  render() {
    return (
      <div className="app">
        <Nav onRun={this.handleRunClick.bind(this)}
          onShare={this.handleShareClick.bind(this)}
          onEmbed={this.handleEmbedClick.bind(this)}
          shareURL={this.state.shareURL}
          embedCode={this.state.embedCode}
          showSharer={this.state.showSharer}
          showEmbedCode={this.state.showEmbedCode} />
        <div className="container-fluid workspace">
          <CodeEditor className="row code-editor-pane"
            code={this.state.code}
            extraKeys={this.state.extraKeys}
            onChange={this.handleCodeEditorChange.bind(this)} />
          <Console className="row console-pane"
            output={this.state.output} />
        </div>
      </div>
    );
  }

  handleCodeEditorChange(e) {
    this.setState({
      code: e.target.value,
      shareURL: "",
      embedCode: "",
      showSharer: false,
      showEmbedCode: false
    });
  }

  handleRunClick() {
    this.sendCode(
      this.state.code,
      function(data) {
        this.setState({output: ""});
        this.streamOutput(data);
      },
      function(xhr, status, err) {
        console.error(status, err);
      }
    );
  }

  sendCode(code, successCb, errorCb) {
    var body = {code: code};
    $.ajax({
      url: '/api/run',
      type: 'POST',
      data: body,
      success: successCb.bind(this),
      error: errorCb.bind(this)
    });
  }

  streamOutput(id) {
    var source = new EventSource("/api/stream/"+id);
    var self = this;

    source.addEventListener('output', function(e) {
      console.log("Output:", e.data);
      self.writeOutput(e.data);
    }, false);

    source.addEventListener('timeout', function(e) {
      console.log(e.data);
      self.writeOutput(e.data);
    }, false);

    source.addEventListener('close', function(e) {
      console.log('Closing stream...');
      source.close();
    }, false);

    source.addEventListener('error', function(e) {
      console.log("Error:", e);
    }, false);
  }

  writeOutput(data) {
    var output = this.state.output;
    output += data + '\n';
    this.setState({output: output});
  }

  handleShareClick() {
    this.setState({showEmbedCode: false});
    this.shareCode();
  }

  handleEmbedClick() {
    this.setState({showEmbedCode: true});
    this.shareCode();
  }

  shareCode() {
    var body = {code: this.state.code};
    $.ajax({
      url: '/api/share',
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
};

React.render(<App/>, document.getElementById('app'));
