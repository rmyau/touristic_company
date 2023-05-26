require 'fox16'
include Fox
require_relative 'tourist/controller/controller'
require_relative 'tourist/views/tab_clients'
# require_relative 'rest/views/tab_rest'


class Window < FXMainWindow
  def initialize(app)
    super(app, "Туристическая компания", width: 1200, height: 450) # увеличиваем размер главного окна
    create_tabs
  end

  def create
    super
    # @controller.refresh_data(@current_page, @students_on_page)
    @first_tab.refresh
    show
  end


  def create_tabs
    # Создаем FXTabBook в главном горизонтальном фрейме
    tab_book = FXTabBook.new(self, :opts=>LAYOUT_FILL_X|LAYOUT_FILL_Y)

    # tab_book = FXTabBook.new(self, nil, 0, LAYOUT_FILL_X|LAYOUT_FILL_Y)
    tab_book.backColor = FXRGB(240, 240, 240) # меняем цвет фона вкладок

    # Create the first tab
    tab1 = FXTabItem.new(tab_book, "Туристы", nil)
    composite1 = FXComposite.new(tab_book, LAYOUT_FILL_X|LAYOUT_FIX_HEIGHT, height: 700,width:1000) # увеличиваем высоту компонента
    # composite1 = FXComposite.new(tab_book, LAYOUT_FILL_X|LAYOUT_FILL_Y)
    @first_tab = TabClient.new(composite1)
    @first_tab.resize(1200, 400)

    # Create the second tab
    tab2 = FXTabItem.new(tab_book, "Вкладка 2", nil)
    composite2 = FXComposite.new(tab_book, LAYOUT_FILL_X|LAYOUT_FILL_Y)
    # @second_tab = TabRest.new(composite2)
    # @second_tab.resize(1000,1000)

    # Create the third tab
    tab3 = FXTabItem.new(tab_book, "Вкладка 3", nil)
    @composite3 = FXComposite.new(tab_book, LAYOUT_FILL_X|LAYOUT_FILL_Y)

    tab_book.connect(SEL_COMMAND) do |sender, selector, data|
      # Получаем индекс текущей вкладки
      current_tab_index = sender.current
      # Обновляем данные в соответствии с текущей вкладкой
      case current_tab_index
      when 0

        @first_tab.refresh
      when 1
        # для второй вкладки
        # @second_tab.refresh
        # when 1
        #   # для второй вкладки
        #   @second_tab.refresh
        # when 2
        #   # для третьей вкладки
        #   @controller.refresh_data_for_tab3
      end
    end
  end

end