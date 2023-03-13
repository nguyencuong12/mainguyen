import 'package:mainguyen/utils/screenSize.dart';

class TextSize {
  getNormalTextSize() {
    return screenSizeWithoutContext.width / 90;
  }

  getLabelTextSize() {
    return screenSizeWithoutContext.width / 70;
  }
}
