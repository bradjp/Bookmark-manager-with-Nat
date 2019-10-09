feature 'delete a bookmark' do
  scenario 'when deleting the first bookmark' do
    Bookmarks.create(url: 'www.miniclip.com', title: 'Miniclip')
    visit '/bookmarks'
    expect(page).to have_content('Miniclip')
    click_button 'Delete'
    expect(page).not_to have_content('Miniclip')
    expect(page).to have_content('Bookmark Manager')
  end
end