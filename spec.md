# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [x] Include at least one has_many relationship (x has_many y; e.g. User has_many Recipes) 
  host has many shows, show has many interviews

- [x] Include at least one belongs_to relationship (x belongs_to y; e.g. Post belongs_to User)
  show belongs to host, interview belongs to show, guest belongs to interview

- [x] Include at least two has_many through relationships (x has_many y through z; e.g. Recipe has_many Items through Ingredients)
  host has many interviews through show, show has many guests through interviews

- [?] Include at least one many-to-many relationship (x has_many y through z, y has_many x through z; e.g. Recipe has_many Items through Ingredients, Item has_many Recipes through Ingredients)
  honestly, not sure if I fulfilled this requirement

- [x] The "through" part of the has_many through includes at least one user submittable attribute, that is to say, some attribute other than its foreign keys that can be submitted by the app's user (attribute_name e.g. ingredients.quantity)
  interview is the join table between guest & show, all tables have multiple user-entered attributes

- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
  all user-entered data attr's validates at least for presence, some validate for uniqueness in addition to that

- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
  using scopes for interviews to differentiate between recorded & published

- [x] Include signup (how e.g. Devise)
  uses separate /signup route

- [x] Include login (how e.g. Devise)
  uses separate /login route

- [x] Include logout (how e.g. Devise)
  uses separate /logout route

- [x] Include third party signup/login (how e.g. Devise/OmniAuth)
  utilizing Oauth via GitHub

- [x] Include nested resource show or index (URL e.g. users/2/recipes)
  hosts/:host_id/shows/:id, hosts/:host_id/shows/:show_id/interviews/:id

- [x] Include nested resource "new" form (URL e.g. recipes/1/ingredients/new)
  hosts/:id/shows/new, hosts/:host_id/shows/:show_id/interviews/new

- [x] Include form display of validation errors (form URL e.g. /recipes/new)
  displaying errors for invalid login, host acct creation, and interview creation

Confirm:
- [x] The application is pretty DRY
  minimal (if any) unnecessary code repetition

- [x] Limited logic in controllers
  login processes are separated to private methods
  
- [x] Views use helper methods if appropriate
  I don't see any places that would benefit from using helpers

- [x] Views use partials if appropriate
  forms are separated into partials