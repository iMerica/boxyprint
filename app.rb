require 'dropbox_sdk'
require 'sinatra'
require 'sinatra/sequel'
require 'stripe'

# y so many constants?
config = YAML::load_file('config.yml')
DROPBOX_APP_KEY = config['dropbox_app_key'] 
DROPBOX_APP_SECRET = config['dropbox_app_secret']
LOB_ACCOUNT_ID = config['lob_account_id']
LOB_API_KEY = config['lob_api_key']
STRIPE_SECRET_KEY = config['stripe_secret_key']
STRIPE_PUBLISHABLE_KEY = config['stripe_publishable_key']
DB_URL = config['database_url']

module BoxyPrint

  class App < Sinatra::Base

    enable :sessions

    set :session_secret, 'Dropbox, Lob, Stripe Mashup!'
    set :database, DB_URL

    migration "create the orders table" do
      database.create_table :orders do
       primary_key :id
       text        :email
       text        :name
       text        :phone
       timestamp   :time
       photo_urls  :text
      end
    end

    class Order < Sequel::Model

    end

    post '/' do

    end

    get '/' do
      erb :index
    end

    get '/pay' do
      # Amount in cents
      @amount = session[:order_amount] ||= 10

      customer = Stripe::Customer.create(
        :email => 'customer@example.com',
        :card  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :amount      => @amount,
        :description => 'Sinatra Charge',
        :currency    => 'usd',
        :customer    => customer.id
      )

      erb :pay
    end

  end

end

