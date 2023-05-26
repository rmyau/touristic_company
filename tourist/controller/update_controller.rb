# frozen_string_literal: true
require_relative 'add_controller'
require 'logger'

class UpdateClientController<AddClientController
  private_class_method :new
  def initialize(client_list, client_id)
    super(client_list)
    @client_id = client_id
    @logger = Logger.new('controller_update.log') # Указывает путь и имя файла для логов
  end

  def save_client(client)
    @logger.info('Saving updated client')
    @client_list.replace_tourist(@client_id, client)
  end

  def add_view(view)
    @logger.info('Adding view to update client controller')
    super(view)
    client = @client_list.tourist_by_id(@client_id)
    @view.set_client(client,get_editable_fields)
  end



  private
  def get_editable_fields; end

end
