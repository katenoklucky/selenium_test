@task10
Feature: Task10 Verify opened page

  Scenario: Open site and verify
    * I use "firefox" browser
    * I open site "http://litecart.stqa.ru/index.php/en/" with title "Online Store | My Store"
    * I get settings for the item on main page:
      | name                              |
      | regular price                     |
      | promotional price                 |
      | color of regular price            |
      | text-decoration of regular price  |
      | font-size of regular price        |
      | color of promotional price        |
      | font-weight of promotional price  |
      | font-size of promotional price    |
#    г) акционная цена крупнее, чем обычная (это тоже надо проверить на каждой странице независимо)
    * I verify font sizes for the item on main page

    * I navigate to "Yellow Duck" item
    * I get settings for the item on item page:
      | name                              |
      | regular price                     |
      | promotional price                 |
      | color of regular price            |
      | text-decoration of regular price  |
      | font-size of regular price        |
      | color of promotional price        |
      | font-weight of promotional price  |
      | font-size of promotional price    |
#    г) акционная цена крупнее, чем обычная (это тоже надо проверить на каждой странице независимо)
    * I verify font sizes for the item on item page

    * I verify settings for the item are equal on pages:
#    а) на главной странице и на странице товара совпадает текст названия товара
      | name                              |
#    б) на главной странице и на странице товара совпадают цены (обычная и акционная)
      | regular price                     |
      | promotional price                 |
#    в) обычная цена зачёркнутая и серая (можно считать, что "серый" цвет это такой, у которого в RGBa представлении одинаковые значения для каналов R, G и B)
      | color of regular price            |
      | text-decoration of regular price  |
#    г) акционная жирная и красная (можно считать, что "красный" цвет это такой, у которого в RGBa представлении каналы G и B имеют нулевые значения)
      | color of promotional price        |
      | font-weight of promotional price  |

  Scenario: Close browser
    * I close the browser via UI

  Scenario: Open site and verify
    * I use "chrome" browser
    * I open site "http://litecart.stqa.ru/index.php/en/" with title "Online Store | My Store"
    * I get settings for the item on main page:
      | name                              |
      | regular price                     |
      | promotional price                 |
      | color of regular price            |
      | text-decoration of regular price  |
      | font-size of regular price        |
      | color of promotional price        |
      | font-weight of promotional price  |
      | font-size of promotional price    |
#    г) акционная цена крупнее, чем обычная (это тоже надо проверить на каждой странице независимо)
    * I verify font sizes for the item on main page

    * I navigate to "Yellow Duck" item
    * I get settings for the item on item page:
      | name                              |
      | regular price                     |
      | promotional price                 |
      | color of regular price            |
      | text-decoration of regular price  |
      | font-size of regular price        |
      | color of promotional price        |
      | font-weight of promotional price  |
      | font-size of promotional price    |
#    г) акционная цена крупнее, чем обычная (это тоже надо проверить на каждой странице независимо)
    * I verify font sizes for the item on item page

    * I verify settings for the item are equal on pages:
#    а) на главной странице и на странице товара совпадает текст названия товара
      | name                              |
#    б) на главной странице и на странице товара совпадают цены (обычная и акционная)
      | regular price                     |
      | promotional price                 |
#    в) обычная цена зачёркнутая и серая (можно считать, что "серый" цвет это такой, у которого в RGBa представлении одинаковые значения для каналов R, G и B)
      | color of regular price            |
      | text-decoration of regular price  |
#    г) акционная жирная и красная (можно считать, что "красный" цвет это такой, у которого в RGBa представлении каналы G и B имеют нулевые значения)
      | color of promotional price        |
      | font-weight of promotional price  |

  Scenario: Close browser
    * I close the browser via UI