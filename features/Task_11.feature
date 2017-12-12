@task11
Feature: Task11 Create user

  Scenario: Open site and verify
    * I use "firefox" browser
    * I open site "http://litecart.stqa.ru/index.php/en/" with title "Online Store | My Store"
    * I create new account with following settings:
      | setting          | value                     |
      | tax_id           | ed_test_tax_id            |
      | company          | ed_test_company           |
      | first_name       | Ekaterina                 |
      | last_name        | Danilova                  |
      | address1         | ed_test_address1          |
      | address2         | ed_test_address2          |
      | postcode         | 12345                     |
      | city             | Ostin                     |
      | country          | United States             |
      | zone             | Texas                     |
      | email            | ed_test_tax_id7@gmail.com |
      | phone            | 9000000000                |
      | desired_password | ed_test_tax_id@gmail.com  |
      | confirm_password | ed_test_tax_id@gmail.com  |

    * I logout from the site
    * I login on the site with following settings:
      | setting  | value                     |
      | email    | ed_test_tax_id3@gmail.com |
      | password | ed_test_tax_id3@gmail.com |
    * I logout from the site

  Scenario: Close browser
    * I close the browser via UI