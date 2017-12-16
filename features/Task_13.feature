@task13
Feature: Task13 Working with cart

  Scenario: Open site and verify
    * I use "firefox" browser
    #    1) открыть главную страницу
    * I open site "http://litecart.stqa.ru/index.php/en/" with title "Online Store | My Store"
    #    2) открыть первый товар из списка
    * I navigate to the first item
    * I get count of cart
    #    2) добавить его в корзину (при этом может случайно добавиться товар, который там уже есть, ничего страшного)
    * I click on "Add To Cart" button
    #    3) подождать, пока счётчик товаров в корзине обновится
    * I wait until count of cart was updated
    #    4) вернуться на главную страницу, повторить предыдущие шаги ещё два раза, чтобы в общей сложности в корзине было 3 единицы товара
    * I open site "http://litecart.stqa.ru/index.php/en/" with title "Online Store | My Store"
    * I navigate to the first item
    * I get count of cart
    * I click on "Add To Cart" button
    * I wait until count of cart was updated
    * I open site "http://litecart.stqa.ru/index.php/en/" with title "Online Store | My Store"
    * I navigate to the first item
    * I get count of cart
    * I click on "Add To Cart" button
    * I wait until count of cart was updated
    #    5) открыть корзину (в правом верхнем углу кликнуть по ссылке Checkout)
    * I click on "Checkout »"
    #    6) удалить все товары из корзины один за другим, после каждого удаления подождать, пока внизу обновится таблица
    * I delete all items from cart

  Scenario: Close browser
    * I close the browser via UI