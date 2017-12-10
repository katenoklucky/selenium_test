@task7
Feature: Task07: Click on each menu and verify H1

  Scenario: Login and verify
    * I use "firefox" browser
    * I login under admin on site "http://localhost/litecart/admin" with title "My Store"
    * I click on each menu and verify existing "h1" tag

  Scenario: Close browser
    * I close the browser via UI

