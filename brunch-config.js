exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: 'js/app.js',
      order: {
        before: [
          "bower_components/react/react-with-addons.js",
          "bower_components/react-codemirror/dist/react-codemirror.js",
          /^web\/static\/vendor/
        ]
      }
    },
    stylesheets: {
      joinTo: 'css/app.css'
    },
    templates: {
      joinTo: 'js/app.js'
    }
  },

  conventions: {
    vendor: /^web\/static\/vendor/,
    assets: /^web\/static\/assets/
  },

  paths: {
    watched: ["deps/phoenix/web/static",
              "deps/phoenix_html/web/static",
              "web/static", "test/static"],
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/],
      compact: false
    }
  },

  modules: {
    autoRequire: {
      'js/app.js': ['web/static/js/app']
    }
  },
};
