/// returns a new copy of the list, where Maps are duplicated x number of times
/// I used it to create huge size copies of lists for performace testing purpose
List<Map<String, dynamic>> createDuplicates(List<Map<String, dynamic>> customerData, int times) {
  List<Map<String, dynamic>> duplicatedList = [];
  for (var map in customerData) {
    for (int i = 0; i < times; i++) {
      duplicatedList.add(Map<String, dynamic>.from(map));
    }
  }
  return duplicatedList;
}
