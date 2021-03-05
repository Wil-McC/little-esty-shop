Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'

  #admins
  resources :admin, only: [:index], controller: "admin/dashboard"

  namespace :admin do
    resources :invoices, only: [:index, :show, :update]
    resources :merchants, only: [:index, :new, :create, :show, :edit, :update]
  end

  #merchants
  resources :merchants, only: [:show] do
    resources :items, only: [:index, :show, :new, :create, :edit, :update], controller: "merchants/items"
    resources :invoices, only: [:index, :show], controller: "merchants/invoices"
    resources :dashboard, only: [:index], controller: "merchants/dashboard"
    resources :discounts, only: [:index, :show], controller: "merchants/discounts"
  end

  #merchants/invoice_items
  resources :invoice_items, only: [:update], controller: "merchants/invoice_items"
end
