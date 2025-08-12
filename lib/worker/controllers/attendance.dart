class AttendanceController {
  String userEmail = "worker@demo.com"; // For example
  DateTime? checkInTime;
  DateTime? checkOutTime;

  // Formatted getters for UI display
  String get formattedCheckInTime =>
      checkInTime != null ? _formatDateTime(checkInTime!) : '';
  String get formattedCheckOutTime =>
      checkOutTime != null ? _formatDateTime(checkOutTime!) : '';

  // Define these boolean getters for button state logic
  bool get isCheckedIn => checkInTime != null && checkOutTime == null;
  bool get isCheckedOut => checkInTime != null && checkOutTime != null;

  void checkIn() {
    if (checkInTime == null) {
      checkInTime = DateTime.now();
      checkOutTime = null; // Reset checkout if any
    }
  }

  void checkOut() {
    if (checkInTime != null && checkOutTime == null) {
      checkOutTime = DateTime.now();
    }
  }

  String _formatDateTime(DateTime dt) {
    // Simple format for demo, customize or use intl package as needed
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} on ${dt.day}/${dt.month}/${dt.year}';
  }
}
