import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF3A7AFE);
const double kRadius = 16.0;

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const CardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0,6))],
      ),
      child: child,
    );
    if (onTap != null) return GestureDetector(onTap: onTap, child: card);
    return card;
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool busy;
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.busy=false});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: busy ? const CircularProgressIndicator(color: Colors.white) : Text(label, style: const TextStyle(fontSize:16)),
      ),
    );
  }
}

class LabeledInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboard;
  final bool obscure;
  const LabeledInput({
    super.key,
    required this.controller,
    required this.label,
    this.keyboard = TextInputType.text,
    this.obscure = false,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal:12, vertical:14),
      ),
    );
  }
}
