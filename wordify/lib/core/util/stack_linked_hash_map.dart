import 'dart:collection';

///A LinkedHashMap data structure with the ability to add to the head of the list.
class StackLinkedHashMap<K, T> {
  final HashMap<K, _Node<T>> _table;
  final _LinkedList<T> _list;


  StackLinkedHashMap() 
    : _table = HashMap<K, _Node<T>>(),
      _list = _LinkedList<T>();


  ///
  void insert(K key, T value) {
    _table[key] = _list.add(value);
  }


  ///
  void update(K key, T value) {
    if (_table.containsKey(key) && _table[key] != null) {
      _Node<T> node = _table[key]!;

      node.data = value;
    }
  }


  ///
  void remove(K key) {
    _Node<T>? node = _table[key];

    _list.remove(node);
    _table.remove(key);
  }


  ///
  bool containsKey(K key) {
    return _table.containsKey(key);
  }


  ///
  T? getBelow(K key) {
    _Node<T>? node = _table[key];

    return node?.below?.data;
  }


  ///
  T? getAbove(K key) {
    _Node<T>? node = _table[key];
    
    return node?.above?.data;
  }


  ///
  T? get getFirst => _list.rootItem;
}



///
class _LinkedList<T> {
  _Node<T>? _root;


  ///
  _Node<T> add(T data) {
    if (_root == null) {
      _root = _Node<T>(data);
    } else {
      _Node<T> current = _Node<T>(data);

      current.below = _root;
      _root!.above = current;
      _root = current;
    }

    return _root!;
  }


  ///
  void remove(_Node<T>? node) {
    if (node != null) {
      if (node == _root) {
        _root = node.below;
        _root?.above = null;
      } else {
        node.above?.below = node.below;
        node.below?.above = node.above;
        node.below = null;
        node.above = null;
      }
    }
  }


  ///
  T? get rootItem => _root?.data;
}



///
class _Node<T> {
  T data;
  _Node<T>? above, below;  

  _Node(this.data);
}