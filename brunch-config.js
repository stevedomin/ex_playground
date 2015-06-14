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
    watched: ["web/static", "test/static"],
    public: "priv/static"
  }

};
