module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/*.rb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/*.js',
    './app/javascript/**/*.js',
    './node_modules/flowbite/**/*.js'
  ],
  plugins: [
    require('flowbite/plugin'),
    require('@tailwindcss/line-clamp')
  ]
}
