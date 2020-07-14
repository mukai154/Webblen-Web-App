import 'dart:html' as html;

import 'package:flutter/material.dart';

extension HoverExtensions on Widget {
  static final appContainer = html.window.document.getElementById('app-container');

  Widget get showCursorOnHover {
    return MouseRegion(
      child: this,
      onHover: (event) => appContainer.style.cursor = "pointer",
      onExit: (event) => appContainer.style.cursor = "default",
    );
  }

  Widget get showTextSelectorOnHover {
    return MouseRegion(
      child: this,
      onHover: (event) => appContainer.style.cursor = "text",
      onExit: (event) => appContainer.style.cursor = "default",
    );
  }
}
