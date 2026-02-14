/// Generates a deterministic integer seed from a calendar date.
///
/// Used by the daily challenge mode to ensure all players get the same
/// obstacle sequence on a given day.
int dailySeedForDate(DateTime date) {
  return date.year * 10000 + date.month * 100 + date.day;
}

/// Convenience wrapper that returns today's daily seed.
int todaysSeed() => dailySeedForDate(DateTime.now());
