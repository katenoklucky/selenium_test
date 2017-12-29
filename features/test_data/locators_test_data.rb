$locators = {
    first_item: {
        finder: 'css',
        selector: '#box-most-popular li:nth-child(1) > a.link'
    },
    count_of_cart: {
        finder: 'css',
        selector: '#cart span.quantity'
    },
    body: {
        finder: 'css',
        selector: 'body'
    },
    select_box: {
        finder: 'css',
        selector: '#box-product select[name="options[Size]"]'
    },
    summary_wrapper: {
        finder: 'css',
        selector: '#checkout-cart-wrapper'
    },
    summary_wrapper_em: {
        finder: 'css',
        selector: '#checkout-cart-wrapper em'
    },
    table: {
        finder: 'css',
        selector: '#table'
    },
    page: {
        finder: 'id',
        selector: 'page'
    },
    login_username: {
        finder: 'name',
        selector: 'username'
    },
    login_password: {
        finder: 'name',
        selector: 'password'
    },
    login: {
        finder: 'name',
        selector: 'login'
    },
    setting_name: {
        finder: 'css',
        selector: '#box-campaigns > div > ul > li > a.link > div.name'
    },
    setting_regular_price: {
        finder: 'css',
        selector: 'ul.listing-wrapper > li.product .regular-price'
    },
    setting_promotional_price: {
        finder: 'css',
        selector: 'ul.listing-wrapper > li.product .campaign-price'
    },
    setting_item_name: {
        finder: 'css',
        selector: '#box-product .title'
    },
    setting_item_regular_price: {
        finder: 'css',
        selector: '#box-product .regular-price'
    },
    setting_item_promotional_price: {
        finder: 'css',
        selector: '#box-product .campaign-price'
    },
}