module.exports = {
  root: true,
  env: {
    browser: true,
    node: true
  },
  parserOptions: {
    parser: "babel-eslint"
  },
  extends: [
    "eslint:recommended",
    "plugin:vue/recommended",
    "plugin:prettier/recommended"
  ],
  // required to lint *.vue files
  plugins: [
    "vue"
  ],
  // custom rules - http://redmine.connectome.design/projects/cod-platform/wiki/Code_Configuration
  rules: {
    "max-len": ["error", { "code": 120 }],
    "indent": ["error", 4],
    "linebreak-style": ["error", "unix"],
    "quotes": ["error", "double"],
    "semi": ["error", "always"],
    //"comma-dangle": ["error", "always"],
    "no-cond-assign": ["error", "always"],
    "no-console": "off",
    "vue/max-attributes-per-line": "off",
    "prettier/prettier": ["error", { "semi": false }],
    "prettier/prettier" : ["off", { "tabWidth": 4}]
  }
}