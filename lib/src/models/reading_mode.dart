enum ReadingMode {
  READING,
  LISTENING;

  String get displayName {
    switch (this) {
      case ReadingMode.READING:
        return 'Reading';
      case ReadingMode.LISTENING:
        return 'Listening';
    }
  }

  String get pastTense {
    switch (this) {
      case ReadingMode.READING:
        return 'Read';
      case ReadingMode.LISTENING:
        return 'Listened';
    }
  }

  bool get isReading => this == ReadingMode.READING;
  bool get isListening => this == ReadingMode.LISTENING;
}
