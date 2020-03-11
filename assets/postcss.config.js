const purgecss = require("@fullhuman/postcss-purgecss")({
  content: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "./js/**/*.js",
    "./js/**/*.re",
    "../**/*_view.ex"
  ],
  // defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || [],
  defaultExtractor: content => content.match(/[\w-/.:]+(?<!:)/g) || []
});

module.exports = {
  plugins: [
    require("postcss-import"),
    require("tailwindcss"),
    require("autoprefixer"),
    require("postcss-nested"),
    ...(process.env.NODE_ENV === "production" ? [purgecss] : [])
  ]
};
