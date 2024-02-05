# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
examples = [
  'Fork this repository into a public repository on your account',
  'Commit early and often. We will likely be following along with your progress',
  'A link to your repository with code in it',
  'A text description of the todo',
  'A checkbox to mark the todo as done or undone',
  'The user should be able to create a new TODO item',
  'The user should be able to destroy a TODO item',
  'The user should be able to update the text description of a TODO item',
  'TODOs should be Created, Updated, Listed, Viewed, and Destroyed via REST or graphQL',
  'TODOs should be stored in your database on the backend',
  'Deploy your TODO app to the internet so we can see it in action',
  'Test it on Mobile device sizes',
  'Write unit tests for your code',
  'Edit this ReadMe with new suggestions for how to improve this code test'
]

examples.each do |example|
  Todo.create(title: example)
end
