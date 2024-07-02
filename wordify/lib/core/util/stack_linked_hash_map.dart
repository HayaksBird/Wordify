import 'dart:collection';

///A LinkedHashMap data structure with the ability to add to the head of the list.
class StackLinkedHashMap<K, T> {
  final HashMap<K, T> _table;
  final List<T> _list;


  StackLinkedHashMap() 
    : _table = HashMap<K, T>(),
      _list = [];


  ///
  void insert(K key, T value) {
    _list.insert(0, value);
    _table[key] = value;
  }


  ///
  void update(K key, T value) {
    if (_table.containsKey(key) && _table[key] != null) {
      int index = _list.indexOf(_table[key]!);

      _table[key] = value;
      _list[index] = value;
    }
  }


  ///
  void remove(K key) {
    T? value = _table[key];
    _list.remove(value);
    _table.remove(key);
  }


  ///
  bool containsKey(K key) {
    return _table.containsKey(key);
  }


  ///
  List<T> getList() {
    return _list;
  }
}