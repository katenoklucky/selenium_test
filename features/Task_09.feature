@task9
Feature: Task09
#  1) a)
  Scenario: Open site and verify
    * I use "firefox" browser
    * I login under admin on site "http://localhost/litecart/admin?app=countries&doc=countries" with title "Countries | My Store"
    * I verify countries order is ascending

  Scenario: Close browser
    * I close the browser via UI
#  1) a)
  Scenario: Open site and verify
    * I use "firefox" browser
    * I login under admin on site "http://localhost/litecart/admin?app=countries&doc=countries" with title "Countries | My Store"
    * I verify countries order is ascending in not null zones

  Scenario: Close browser
    * I close the browser via UI
#  2)
  Scenario: Open site and verify
    * I use "firefox" browser
    * I login under admin on site "http://localhost/litecart/admin/?app=geo_zones&doc=geo_zones" with title "Geo Zones | My Store"
    * I verify zones order is ascending for each county

  Scenario: Close browser
    * I close the browser via UI