# frozen_string_literal: true
#
require_relative '../../window'
require_relative '../source_model/tourist_list'
require_relative '../source_model/tourist_db_adapter'
require_relative '../source_model/containers/data_list_client_short'
require_relative 'add_controller'
require_relative '../views/dialog_create_client'
require_relative '../model/tourist'
require_relative 'update_controller'
require_relative 'update/update_name_controller'
require_relative 'update/update_contact_controller'
require_relative 'update/update_address_controller'
require 'win32api'
require 'fox16'
include Fox
require 'logger'
require_relative  '../../copy_bd'


class ClientListController
  def initialize(view)
    @view = view
    @data_list = DataListTouristShort.new([])
    @data_list.add_observer(@view)
    @client_list = TouristList.new(TouristDBAdapter.new)
    @logger = Logger.new('tourist/controller.log') # Указывает путь и имя файла для логов
    do_backup
  end


  def refresh_data(k_page, number_clients)
    begin
    @logger.info("Refreshing data with k_page=#{k_page} and number_clients=#{number_clients}")
    @data_list = @client_list.get_k_n_tourist_short_list(k_page, number_clients, @data_list)
    rescue SQLite3::SQLException => e
      @logger.error("Error occurred while refreshing data: #{e.message}")
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, "No connection to DB", "Error", 0)
      exit(false)
    else
      @logger.info("Data refreshed successfully with k_page=#{k_page} and number_clients=#{number_clients}")
  end
    @view.update_count_clients(@client_list.tourist_count)
  end


  def client_add
    @logger.info('Add tourist')
    controller = AddClientController.new(@client_list)
    show_dialog(controller)
  end

  private
  #изменение студента
  def get_client_id(index)
    @data_list.select(index)
    id = @data_list.get_select
    @data_list.clear_selected
    id
  end

  public
  def client_change_name(index)
    @logger.info('Changing tourist name')
    puts 'update name'
    id = get_client_id(index)
    controller = ChangeClientNameController.new(@client_list, id)
    show_dialog(controller)
  end


  def client_change_contact(index)
    @logger.info('Changing tourist contact')
    puts 'update contact'
    id = get_client_id(index)
    controller = ChangeClientContactController.new(@client_list, id)
    show_dialog(controller)
  end

  def client_change_address(index)
    @logger.info('Changing tourist address')
    id = get_client_id(index)
    controller = ChangeClientAddressController.new(@client_list, id)
    show_dialog(controller)
  end


  def client_delete(indexes)
    @data_list.select(*indexes)
    id_list = @data_list.get_select
    @data_list.clear_selected

    id_list.each{|client_id| @client_list.remove_tourist(client_id)}
    @view.refresh
    @logger.info("Deleted tourist with IDs: #{id_list.join(', ')}")
  end

  private
  def show_dialog(controller)
    # controller = AddStudentController.new(@student_list)
    view = CreateClientDialog.new(@view, controller)
    controller.add_view(view)
    controller.execute
    @view.refresh
  end


end
