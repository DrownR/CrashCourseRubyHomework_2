# frozen_string_literal: true

require 'capybara/rspec'
require_relative 'spec_helper'


RSpec.describe 'Login Tests' do

  before(:each) do
    @driver = Capybara::Session.new(:selenium)
  end
  
  context "Login to account and add item to cart" do      
    user_field = 'user-name'
    password_field = 'password'
    usernames = ['standard_user', 'error_user', 'locked_out_user']
    correctPassword = 'secret_sauce'

    usernames.each do |username|     
      it "user:#{username} log into his account and trying add item to cart" do       
        @driver.visit Capybara.app_host
        set_text_to_field(user_field, username)

        expect(@driver).to have_field(password_field)
        
        if username == 'locked_out_user'       #locked user  
          set_text_to_field(password_field, correctPassword)
          @driver.click_button('Login')
          expect(@driver).to have_selector('[data-test="error"]', text: "Epic sadface: Sorry, this user has been locked out.")       
        elsif username == 'error_user'
          set_text_to_field(password_field, '1')
          @driver.click_button('Login')
          expect(@driver).to have_selector('[data-test="error"]', text: "Epic sadface: Username and password do not match any user in this service")   
        else
          set_text_to_field(password_field, correctPassword)
          @driver.click_button('Login')
          #cart first item
          item_id = '#add-to-cart-sauce-labs-backpack'      
          item = get_item_by_id(item_id)
          add_to_cart_item(item)

          item_id = '#remove-sauce-labs-backpack'
          item = get_item_by_id(item_id)

          expect(get_item_by_id(item_id).text).to eql("Remove")

          #cart second item
          item_id = '#add-to-cart-sauce-labs-bike-light'      
          item = get_item_by_id(item_id)
          add_to_cart_item(item)

          item_id = '#remove-sauce-labs-bike-light'
          item = get_item_by_id(item_id)
          
          expect(get_item_by_id(item_id).text).to eql("Remove")     
        end  
      end           
    end
  end

  def set_text_to_field(field, text)
     @driver.fill_in field, with: text
  end

  def add_to_cart_item_by_id(id)
    add_button = @driver.find(id)
    add_button.click
    add_button
  end

  def get_item_by_id(id)
    @driver.find(id)
  end

  def add_to_cart_item(item)
    item.click
  end
end
