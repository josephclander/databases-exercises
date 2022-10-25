require 'recipe_repository'

describe RecipeRepo do
  def reset_recipes_table
    seed_sql = File.read('spec/seeds_recipes.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes_directory_test' })
    connection.exec(seed_sql)
  end

  before :each do
    reset_recipes_table
  end

  it 'returns the list of recipes' do
    repo = RecipeRepo.new

    recipes = repo.all
    expect(recipes.length).to eq 3

    expect(recipes[0].id).to eq '1'
    expect(recipes[0].name).to eq 'Pasta'
    expect(recipes[0].cooking_time).to eq '12'
    expect(recipes[0].rating).to eq '1'

    expect(recipes[1].id).to eq '2'
    expect(recipes[1].name).to eq 'Toast'
    expect(recipes[1].cooking_time).to eq '5'
    expect(recipes[1].rating).to eq '2'

    expect(recipes[2].id).to eq '3'
    expect(recipes[2].name).to eq 'Fajitas'
    expect(recipes[2].cooking_time).to eq '40'
    expect(recipes[2].rating).to eq '5'
  end

  it 'returns a single recipe' do
    repo = RecipeRepo.new
    recipe = repo.find(3)
    expect(recipe.id).to eq '3'
    expect(recipe.name).to eq 'Fajitas'
    expect(recipe.cooking_time).to eq '40'
    expect(recipe.rating).to eq '5'
  end
end
