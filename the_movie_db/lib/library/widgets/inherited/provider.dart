import 'package:flutter/material.dart';

class NotifierProvider<Model extends ChangeNotifier> extends StatefulWidget {
  final Model Function() create;
  final Widget child;
  final bool isManageModel;
  const NotifierProvider({
    Key? key,
    this.isManageModel = true,
    required this.child,
    required this.create,
  }) : super(key: key);

  @override
  _NotifierProviderState<Model> createState() =>
      _NotifierProviderState<Model>();

  static Model? watch<Model extends ChangeNotifier>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedNotifierProvider<Model>>()
        ?.model;
  }

  static Model? read<Model extends ChangeNotifier>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            InheritedNotifierProvider<Model>>()
        ?.widget;
    return widget is InheritedNotifierProvider<Model> ? widget.model : null;
  }
}

class _NotifierProviderState<Model extends ChangeNotifier>
    extends State<NotifierProvider<Model>> {
  late final Model _model;

  @override
  void initState() {
    super.initState();
    _model = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedNotifierProvider(
      child: widget.child,
      model: _model,
    );
  }

  @override
  void dispose() {
    if (widget.isManageModel) {
      _model.dispose();
    }

    super.dispose();
  }
}

class InheritedNotifierProvider<Model extends ChangeNotifier>
    extends InheritedNotifier {
  final Model model;
  InheritedNotifierProvider(
      {Key? key, required Widget child, required this.model})
      : super(
          key: key,
          child: child,
          notifier: model,
        );
}

class Provider<Model> extends InheritedNotifier {
  final Model model;
  Provider({Key? key, required Widget child, required this.model})
      : super(
          key: key,
          child: child,
        );

  static Model? watch<Model extends ChangeNotifier>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<Model>>()?.model;
  }

  static Model? read<Model>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<Provider<Model>>()
        ?.widget;
    return widget is Provider<Model> ? widget.model : null;
  }

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return model != oldWidget.model;
  }
}
