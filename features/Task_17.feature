@task17
Feature: Task17 Check browser logs

  Scenario: Open site and verify
    * I use "chrome" browser
  #  1) зайти в админку
    * I login under admin on site "http://litecart.stqa.ru/admin/" with title "My Store"
  #  2) открыть каталог, категорию, которая содержит товары (страница http://localhost/litecart/admin/?app=catalog&doc=catalog&category_id=1)
    * I navigate to "Catalog" menu item on the site
  #  3) последовательно открывать страницы товаров и проверять, не появляются ли в логе браузера сообщения (любого уровня)
    * I open each folder
    * I open each item and verify logs

  Scenario: Close browser
    * I close the browser via UI