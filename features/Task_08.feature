@task8
Feature: Task08: Verify all stickers on main page

  Scenario: Open site and verify
    * I open site "http://litecart.stqa.ru/index.php/en/" with title "Online Store | My Store"
    * I verify all stickers on opened page

  Scenario: Close browser
    * I close the browser via UI

