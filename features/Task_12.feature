@task12
Feature: Task12 Create new item

  Scenario: Open site and verify
    * I use "firefox" browser
    * I login under admin on site "http://litecart.stqa.ru/admin/" with title "My Store"
    * I navigate to "Catalog" menu item on the site
    * I click on "Add New Product"
    * I fill "General" tab with the following settings:
      | setting             | value                              |
      | status              | enabled                            |
      | name                | ed_item_1                          |
      | code                | ed_item_1                          |
      | categories          | Root,Subcategory                   |
      | default_category    | Root                               |
      | product_groups      | Female,Male                        |
      | quantity            | 123                                |
      | quantity_unit       | kgs                                |
      | delivery_status     | 3-5 days                           |
      | sold_out_status     | Temporary sold out                 |
      | image_path          | item.jpg                           |
      | date_valid_from     | 2017-12-09                         |
      | date_valid_to       | 2020-05-23                         |

    * I fill "Information" tab with the following settings:
      | setting             | value                              |
      | manufacturer        | ACME Corp.                         |
      | supplier            | Dart                               |
      | keywords            | ed new item                        |
      | short_description   | short description ed_item_1        |
      | description         | test test test test test test test |
      | head_title          | head_title ed_item_1               |
      | meta_description    | meta_description ed_item_1         |

    * I fill "Prices" tab with the following settings:
      | setting             | value                              |
      | price               | 15.3                               |
      | price_currency_code | Euros                              |
      | tax_class_id        | Tax First                          |
      | gross_prices_usd    | 20.4                               |
      | gross_prices_eur    | 30.5                               |

    * I click on "Save" button

    * I verify "ed_item_1" items exists in catalog by path:
    | [Root]                          |
    | [Root]/Rubber Ducks/Subcategory |

  Scenario: Close browser
    * I close the browser via UI