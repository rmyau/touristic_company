
# frozen_string_literal: true
class TouristList

  # конструктор
  def initialize(data_adapter)
    @data_adapter = data_adapter
  end

  # получить студента по id
  def tourist_by_id(tourist_id)
    @data_adapter.tourist_by_id(tourist_id)
  end


  #добавление студента
  def add_tourist(tourist)
    @data_adapter.add_tourist(tourist)
  end

  #отчисление студента
  def remove_tourist(tourist_id)
    @data_adapter.remove_tourist(tourist_id)
  end

  #замена студента
  def replace_tourist(tourist_id, tourist)
    @data_adapter.replace_tourist(tourist_id,tourist)
  end

  #подсчет количества студентов
  def tourist_count
    @data_adapter.tourist_count
  end

  #получение n элементов k страницы
  def get_k_n_tourist_short_list(k,n,data_list)
    @data_adapter.get_k_n_tourist_short_list(k,n,data_list)
  end
end
