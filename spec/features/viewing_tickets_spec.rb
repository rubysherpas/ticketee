require "rails_helper"

RSpec.feature "Users can view tickets" do
  before do
    vscode = FactoryBot.create(:project, name: "Visual Studio Code")
    FactoryBot.create(:ticket, project: vscode,
      name: "Make it shiny!",
      description: "Gradients! Starbursts! Oh my!")

    ie = FactoryBot.create(:project, name: "Internet Explorer")
    FactoryBot.create(:ticket, project: ie,
      name: "Standards compliance", description: "Isn't a joke.")

    visit "/"
  end

  scenario "for a given project" do
    click_link "Visual Studio Code"

    expect(page).to have_content "Make it shiny!"
    expect(page).to_not have_content "Standards compliance"

    click_link "Make it shiny!"
    within(".ticket h2") do
      expect(page).to have_content "Make it shiny!"
    end

    expect(page).to have_content "Gradients! Starbursts! Oh my!"
  end
end
