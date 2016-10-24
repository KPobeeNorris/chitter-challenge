require 'spec_helper'

feature 'Signing up to Chitter' do

  def sign_up(email: 'bob@bob.com',
    password: 'bob123',
    password_confirmation: 'bob123')
    visit '/users/new'
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Create'
  end

  scenario 'requires a matching confirmation password' do

    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
  end

  scenario 'Create a new user' do
    sign_up
    expect(User.first.email).to eq('bob@bob.com')
  end

  scenario 'I cannot sign up without an email address' do
    expect { sign_up(email: nil) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email must not be blank')
  end

  scenario 'when passwords don\'t match' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Your passwords do not match, please try again!'
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up
    expect { sign_up }.to_not change(User, :count)
    expect(page).to have_content('Email is already taken')
  end

  scenario 'I cannot sign up with an invalid email address' do
    expect { sign_up(email: "invalid@email") }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email has an invalid format')
  end

end