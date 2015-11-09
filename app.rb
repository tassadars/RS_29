#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'haml'
require 'pony'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
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
  erb :visit
end

post '/visit' do
  session[:username] = params['username']
  session[:phone] = params['phone']
  session[:datetime] = params['datetime']
  session[:barber] = params['barber']
  session[:color] = params['color']

  b = Client.new :name => session[:username],
  				 :phone => session[:phone],
  				 :datestamp => session[:datetime],
  				 :barber => session[:barber],
  				 :color => session[:color]
  b.save

  session[:username] = ''
  session[:phone] = ''
  session[:datetime] = ''
  session[:barber] = ''
  session[:color] = ''
  erb 'Дорогой <%=session[:username]%>, ваша заявка принята на рассмотрение. Парикмахер <%=session[:barber]%> вам перезвонит!'
end


get '/contacts' do
  erb :contacts
end

post '/contacts' do
  session[:email] = params['email']
  session[:message] = params['message']


  session[:email] = ''
  session[:message] = ''  
  erb 'Дорогой <%=session[:username]%>, вашe сообщение принято. Мы вам ответим в близжайшее время!'
end

