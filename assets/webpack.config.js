const path = require('path')

const CopyWebpackPlugin = require('copy-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const env = process.env.MIX_ENV || 'dev'
const isProduction = (env === 'prod')

module.exports = {
  entry: "./js/app.js",
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: [
          {loader: 'ts-loader'}
        ]
      }
    ],
  },
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/app.js"
  },
  plugins: [
    new CopyWebpackPlugin([{from: './static'}])
  ],
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
