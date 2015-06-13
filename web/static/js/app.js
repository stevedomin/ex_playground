import React from 'bower_components/react/react-with-addons'
import $ from 'bower_components/jquery/dist/jquery'

import CodeEditor from './components/code-editor'
import Console from './components/console'
import Nav from './components/nav'



class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      output: "",
      code: 'IO.puts "hello"',
      extraKeys: {
        "Cmd-Enter": function(editor) {
          this.handleRunClick()
        }.bind(this)
      }
    };
  }

  render() {
    return (
      <div>
        <Nav onRun={this.handleRunClick.bind(this)}
          onShare={this.handleShareClick.bind(this)} />
        <CodeEditor code={this.state.code}
          extraKeys={this.state.extraKeys}
          onChange={this.handleCodeEditorChange.bind(this)} />
        <Console output={this.state.output} />
      </div>
    );
  }

  handleCodeEditorChange(e) {
    this.setState({code: e.target.value});
  }

  handleRunClick() {
    this.sendCode("",
      function(data) {
        this.setState({output: ""});
        this.streamOutput(data);
      },
      function(xhr, status, err) {
        console.error(status, err);
      }
    );
  }

  handleShareClick() {
    console.log("share");
    console.log(this);
  }

  sendCode(code, successCb, errorCb) {
    var body = {
      code: this.state.code
    };

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
};

React.render(<App/>, document.getElementById('app'));
