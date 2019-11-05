class Holidays{
  final String id;
  final DateTime date;
  final String reason;

  Holidays(this.id,this.date, this.reason);
   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': date,
      'reason': reason
    };
  }
}