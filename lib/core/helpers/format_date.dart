  String formatDateForDisplay(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "Today";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        return "${date.day.toString().padLeft(2, '0')}."
            "${date.month.toString().padLeft(2, '0')}."
            "${date.year}";
      }
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }