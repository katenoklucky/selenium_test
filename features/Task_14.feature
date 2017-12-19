@task14
Feature: Task14 Check links

  Scenario: Open site and verify
    * I use "firefox" browser
  #  1) зайти в админку
    * I login under admin on site "http://litecart.stqa.ru/admin/" with title "My Store"
  #  2) открыть пункт меню Countries (или страницу http://localhost/litecart/admin/?app=countries&doc=countries)
    * I navigate to "Countries" menu item on the site
  #  3) открыть на редактирование какую-нибудь страну или начать создание новой
    * I click on Edit for "Canada" country
  #  4) возле некоторых полей есть ссылки с иконкой в виде квадратика со стрелкой -- они ведут на внешние страницы и открываются в новом окне, именно это и нужно проверить.
    * I open all windows

  Scenario: Close browser
    * I close the browser via UI