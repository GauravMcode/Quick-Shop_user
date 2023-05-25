# Quickly

User Application for the Full Stack Online Marketplace Project -> "Quickly". This App has been built using **Flutter** and uses **Node.js's Express framework** based REST-API for backend server, which in turn uses **MongoDB** as Database.

Also see :
   **Admin App** : [Quickly Admin](https://github.com/GauravMcode/Quick-Shop_admin)<br>
   **Rest-Api**  : [Quickly Api](https://github.com/GauravMcode/Quick-shop_API)  

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
presentation
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
presentaion
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
## App screens:
The App starts with a splash screen, followed by a Start page, that specifies outlook of the app & link for authentication :

<p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/dd945c65-2c46-493e-9348-91b0a9ca2f0d" width="300" height="600" alt="Quickly-user-start" >
</p>


### The Authentication Pages : 
SignUp & LogIn:
On Sign-up, an account is created for user & user recieves a Welcome email from **Quickly**, user can log-in with the credentials. 

<pre>
<p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/cd23917e-7fa8-4419-85ee-20779fa71495" width="250" height="500" alt="Sign up" >               <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/3da09483-d0ac-49a8-a2e4-d6223e732567" width="250" height="500" alt="log-in" >         
</p>
</pre>

Reset Password : 
User has to enter email and OTP to change password would be sent to their email address.
<pre>
<p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/e4283dc8-46ed-47ab-951b-abd9e39fd4af" width="250" height="500" alt="reset" >            <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/e9538e22-1a0d-47f2-84d2-5385159416c0" width="250" height="500" alt="reset-email" >      <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/c44e5ea2-b107-43e9-85e7-ff4b67c9c4ce" width="250" height="500" alt="reset-otp" >   
</p>
</pre>

### Home-Page :
View products, add to wishlist, search products, remove from wishlist, view profile
<pre>
<p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/2e5597d0-0bcb-454c-b1df-9297e9d508a6" width="250" height="500" alt="Quickly-user-homepage" >               <img src=https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/cc755d88-9bfa-419f-aed4-48b2f3abf5fa" width="250" height="500" alt="homepage" >         
</p>
</pre>
   
### Product Page:
View Product, details, **Add to Cart**, Add and remove from wishlist, view and add reviews.
 <pre>
<p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/f2078f01-bf60-4e88-8cfb-ddb0e104ddb0" width="250" height="500" alt="Quickly-user-product" >         <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/d3c12b6e-e169-4589-870f-79ab632af69d" width="250" height="500" alt="add-cart" >            <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/54287c12-e189-46a7-9c57-ad57958f0d04" width="250" height="500" alt="product" >      <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/6251c4ef-c413-42bc-8143-ed790f3c9698" width="250" height="500" alt="product-2" >        <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/1b6c32e3-b5de-4003-96d9-4bfb06a040de" width="250" height="500" alt="add-cart2" >      
</p>
</pre>
   
 ### Cart Page:
 View items in cart, increase or decrease quantity

 <p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/2cabbecd-7d86-49ce-99b5-c453d9da0f23" width="300" height="600" alt="Quickly-user-Cart" >
</p>
   
### Order :
View items in cart, Selcet Address, or currrent location, or add a new address, review order & proceed to payment, download and view invoice.
   
 <pre>
<p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/8a438b73-1dec-4110-a11f-1139f762eb90" width="250" height="500" alt="Quickly-user-order" >         <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/8c8051df-754e-48ff-85ca-11cf75a15701" width="250" height="500" alt="cart-items" >            <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/0543c3aa-70c7-4db3-85e8-02f841a44401" width="250" height="500" alt="address-1" >      <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/9a37352b-ff34-4719-8174-5137ab29e9e9" width="250" height="500" alt="address-2" >    
</p>
</pre>
   
### Profile :
View Profile, edit photo, view and delete address, view orders, Sign Out

 <pre>
<p align="center">
<img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/cd3ccb48-cd28-42d6-82aa-974e6107e5bd" width="250" height="500" alt="profile" >         <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/57388793-e485-4429-a488-bb755ac8746b" width="250" height="500" alt="profile2" >            <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/f8268dbf-aa3b-4544-904d-f22f25572a72" width="250" height="500" alt="orders" >      <img src="https://github.com/GauravMcode/Quick-Shop_user/assets/51371766/b0ff103f-012f-4a6f-b9c6-8df7022f4cb7" width="250" height="500" alt="profile-pic" >    
</p>
</pre>
