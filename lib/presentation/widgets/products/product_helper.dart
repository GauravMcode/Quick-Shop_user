import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';

class Rating extends StatefulWidget {
  const Rating({super.key, required this.prodId});
  final String prodId;

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double _rating = 0;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Rating & Review'),
        const SizedBox(height: 10),
        RatingBar.builder(
            initialRating: 0.0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 50,
            itemPadding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            }),
        const SizedBox(height: 20),
        PhysicalModel(
          elevation: 40,
          shape: BoxShape.circle,
          color: Colors.grey,
          child: TextField(
            controller: reviewController,
            autocorrect: true,
            enableSuggestions: true,
            maxLines: 5,
            onEditingComplete: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onSubmitted: (newValue) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              hintText: 'Your Review',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              fillColor: Colors.white,
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
              contentPadding: const EdgeInsets.all(20),
              filled: true,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 175,
          child: ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(AddReviewEvent(
                    prodId: widget.prodId,
                    name: context.read<UserBloc>().state.name,
                    rating: _rating,
                    review: reviewController.text,
                  ));
              reviewController.clear();
            },
            child: const Text('Submit', textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}

class EstimateDelivery extends StatefulWidget {
  const EstimateDelivery({
    super.key,
  });

  @override
  State<EstimateDelivery> createState() => _EstimateDeliveryState();
}

class _EstimateDeliveryState extends State<EstimateDelivery> {
  //Demo implementaion for estimate delievery. However in real application, estimate time can be calculated.
  bool estimate = false;
  TextEditingController pincodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FormFieldInput('Pincode', false, pincodeController, inputType: TextInputType.number, width: 150, height: 50),
          CircleAvatar(
              child: IconButton(
            onPressed: () {
              if (pincodeController.text.length == 5) {
                setState(() {
                  estimate = true;
                });
              }
              pincodeController.clear();
            },
            icon: const Icon(Icons.location_on_outlined),
          )),
        ]),
        const SizedBox(height: 10),
        estimate
            ? const Text(
                '"Delivered Estimated in 3 days"',
                style: TextStyle(fontSize: 15),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class Description extends StatefulWidget {
  const Description({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isExpanded
            ? Text(widget.product.description, style: Theme.of(context).textTheme.displayMedium)
            : Text(
                '${widget.product.description.substring(0, (widget.product.description.length / 4).ceil())}...',
                style: Theme.of(context).textTheme.displayMedium,
              ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(isExpanded ? 'Read Less' : 'Read More'),
        )
      ],
    );
  }
}
