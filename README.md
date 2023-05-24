# User Shop

User Application for the Full Stack Online Marketplace Project. This App has been built using **Flutter** and uses **Node.js's Express framework** based REST-API for backend server, which in turn uses **MongoDB** as Database.

## Core feautures of User App :
- Create Account & recieve Welcome email
- Log-in to account & Reset password using OTP through email
- Display list of product, general or category-wise
- Search Bar to search and recieve real-time product results
- View Product
- Add or remove product from wish-list
- give rating and review to product & view other reviews
- Add to Cart & increse or decrease quantity
- 3 step order flow : 
   -  Address Step : Choose form saved address or select Location on Map or Add a new Address
   -  Review Order : Review order & proceed to payment, handled via Stripe
   -  Order Placed : After Successfully placing order, Download & view Invoice generated.
- View all previous orders, with details and invoice 
- Add & edit Profile image, view and remove saved addresses
- Sign out

## Folder Structre:
This Project follows Clean Architecture using BLoC Pattern, where code is seperated into :

```
|- Data Layer
|- Domain Layer
|- Presentation Layer
```
The complete Folder Structe is as follows :

The **lib** folder consists :
```
lib
|- data
|- domain
|- presentation
|- config
|- main.dart
```
The **data** sub-folder handles all calls for data, local or remote

```
data
  |- local
     |- local_data.dart
  |- remote
     |- remote_data.dart
```
The **domain** sub-folder has models and repositories :
```
domain
  |- models
    |- product.dart
    |- user.dart
  |- repositories
    |- auth_repository.dart
    |- cart_repository.dart
    |- map_repository.dart
    |- order_repository.dart
    |- product_repository.dart
    |- user_repository.dart
```
The **presentation** sub-folder consists all UI part and bloc; widgets contain refactored and re-usable widgets.

UI part:

```
   |- pages
     |- authentication
        |- start.dart
        |- sign_up.dart
        |- sign_in.dart
        |- reset_password.dart
     |- cart
         |-cart_items.dart
     |- order
         |- map.dart
         |- order_details.dart
         |- orders.dart
     |- product
         |- products.dart
         |- product.dart
         |- wishlist.dart
     |- profile
         |- prodile.dart
     |- home_page.dart
   |- widgets
      |- cart
         |- cart_animation.dart
      |- order_steps
         |- address_step.dart
         |- order_placed.dart
         |- review_details.dart
      |- products
         |- curved_appbar.dart
         |- horizontal_scroll_list.dart
         |- product_helper.dart
         |- products_helper.dart
      |- input_field.dart
```
**BLoc** :
```
 |- Bloc
   |- bloc
     |- auth_bloc.dart
     |- cart_bloc.dart
     |- map_bloc.dart
     |- order_bloc.dart
     |- product_bloc.dart
     |- user_bloc.dart
     |- util_bloc.dart
   |- events
     |- auth_events.dart
     |- cart_events.dart
     |- map_events.dart
     |- order_events.dart
     |- product_events.dart
     |- user_events.dart
     |- util_events.dart
```

