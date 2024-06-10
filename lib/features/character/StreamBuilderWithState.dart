import 'dart:async';

import 'package:flutter/material.dart';

class StreamBuilderWithState<T> extends StatefulWidget {
  final Stream<T> stream;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<T> snapshot,
  ) builder;

  const StreamBuilderWithState({
    required this.stream,
    required this.builder,
    super.key,
  });

  @override
  State<StreamBuilderWithState<T>> createState() =>
      _CharactersProviderState<T>();
}

class _CharactersProviderState<T> extends State<StreamBuilderWithState<T>> {
  late StreamSubscription<T> _streamSubscription;
  T? _state;

  @override
  void initState() {
    super.initState();
    _streamSubscription = widget.stream.listen((T state) {
      setState(() {
        _state = state;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (_state != null) {
          return widget.builder(
            context,
            AsyncSnapshot.withData(snapshot.connectionState, _state!),
          );
        } else {
          return widget.builder(
            context,
            snapshot,
          );
        }
      },
    );
  }
}
