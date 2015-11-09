#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'haml'
require 'pony'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
	validates :name, presence: true, length: {minimum: 3}
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true
	
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
end

get '/' do

	#@barbers = Barber.all
	@barbers = Barber.order "id DESC"
	erb :index
end


before '/visit' do
	@barbers = Barber.order "id DESC"
end

get '/visit' do
  @c = Client.new 
  erb :visit
end

post '/visit' do

  @c = Client.new params[:client]
  if @c.save
  	erb '<h2>Спасибо, заявка принята!</h2>'
  else
  	@error = @c.errors.full_messages.first
  	erb :visit
  end
end


get '/contacts' do
  erb :contacts
end

post '/contacts' do
  session[:email] = params['email']
  session[:message] = params['message']

  c = Contact.new
  c.email = session[:email]
  c.message = session[:message]
  c.save

  session[:email] = ''
  session[:message] = ''  
  erb 'Дорогой <%=session[:username]%>, вашe сообщение принято. Мы вам ответим в близжайшее время!'
end

get '/barber/:id' do
	erb "This is gonna be barber page, dude."
end