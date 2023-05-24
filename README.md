# user_shop

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
- sign out

## Folder Structre:
This Project follows Clean Architecture using BLoC Pattern, where code is seperated into :

```
|- Data Layer
|- Domain Layer
|- Presentation Layer
```
The complete Folder Structe is as follows :

```
lib
|- data
   |- local
      |- local_data.dart
   |- remote
       |- remote_data.dart
|- domain
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
|- presentation
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
   |- pages
         |- authentication
         |- cart
         |- order
         |- product
         |- profile
         |- home_page.dart
   |- widgets
|- config
|- main.dart
```
