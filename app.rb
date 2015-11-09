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
	validates :email, presence: true
	validates :message, presence: true
end

get '/' do

	#@barbers = Barber.all
	@barbers = Barber.order "id DESC"
	erb :index
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
  @ct = Contact.new
  erb :contacts
end

post '/contacts' do

  @ct = Contact.new params[:contact]
  if @ct.save
  	  	erb '<h2>Спасибо, сообщение принято!</h2>'
  else
  	@error = @ct.errors.full_messages.first
  	erb :contacts
  end
end

get '/barber/:id' do
	@barber = Barber.find(params[:id])
	erb :barber
end


get '/bookings' do
	@clients = Client.order('id DESC')
	erb :bookings 
end

get '/client/:id' do
	@client = Client.find(params[:id])
	erb :client
end