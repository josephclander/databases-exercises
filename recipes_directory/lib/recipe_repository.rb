require_relative './recipe'

# recipe repo class
class RecipeRepo
  def all
    sql = 'SELECT id, name, cooking_time, rating FROM recipes'
    result_set = DatabaseConnection.exec_params(sql, [])

    recipes = []

    result_set.each do |record|
      recipe = Recipe.new
      recipe.id = record['id']
      recipe.name = record['name']
      recipe.cooking_time = record['cooking_time']
      recipe.rating = record['rating']

      recipes << recipe
    end
    recipes
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    sql = 'SELECT id, name, cooking_time, rating FROM recipes WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]

    recipe = Recipe.new
    recipe.id = record['id']
    recipe.name = record['name']
    recipe.cooking_time = record['cooking_time']
    recipe.rating = record['rating']

    recipe
  end
end
