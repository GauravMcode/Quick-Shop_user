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
- view and remove saved addresses
- sign out

## Folder Structre:
This Project follows Clean Architecture usin BLoC Pattern, where code is seperated into :

```
|- Data Layer
|- Domain Layer
|- Presentation Layer
```
