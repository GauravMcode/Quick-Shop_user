abstract class CartEvents {}

class CartEvent extends CartEvents {
  String prodId;
  String task;
  CartEvent({required this.prodId, required this.task});
}

class ResetCartEvent extends CartEvents {}
