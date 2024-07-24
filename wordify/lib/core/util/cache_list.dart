class CacheList<T, R> {
  final int _listSize;
  final List<_Tuple<T, R>> _list;


  CacheList(int listSize)
    : _listSize = listSize > 0 ? listSize : 5,
      _list = [];

  
  ///
  void add(T key, R value) {
    if (_list.length == _listSize) {
      _list.removeAt(_listSize - 1);
      _list.insert(0, _Tuple(key, value));
    } else { _list.insert(0, _Tuple(key, value)); }
  }


  ///
  void remove(T key) {
    _list.removeWhere((tuple) => tuple.key == key);
  }


  ///
  void update(T key, R oldItem, R newItem) {
    int index = _list.indexWhere((element) => element.key == key);
    if (index != -1) { _list[index] = _Tuple(key, newItem); }
  }


  ///
  bool contains(T key) {
    int index = _list.indexWhere((element) => element.key == key);

    if (index != -1) { return true; }
    else { return false; }
  }


  ///
  R? get(T key) {
    int index = _list.indexWhere((element) => element.key == key);

    if (index != -1) { return _list[index].value; }
    else { return null; }
  }
}


class _Tuple<T, R> {
  T key;
  R value;


  _Tuple(this.key, this.value);
}