const path = require('path')

module.exports = {
  entry: "./js/app.js",
  module: {
    loaders: [{
      test: /\.tsx?$/,
      loader: 'ts-loader'
    }]
  },
  output: {
    path: path.resolve(__dirname, "../priv/static/js"),
    filename: "app.js"
  },
  resolve: {
    extensions: [
      '.js',
      '.jsx',
      '.ts',
      '.tsx'
    ],
    modules: [
      "node_modules",
      path.resolve(__dirname, "./js")
    ]
  }
}
