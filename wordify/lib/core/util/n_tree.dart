import 'dart:collection';

///
class NTree<T> {
  late final _NTreeNode<T>? _root;
  late final HashMap<T, _NTreeNode<T>> _itemInTree;


  ///Set the outter most layer
  void setRoot(List<T> items) {
    if (items.isEmpty) {
      throw ArgumentError('Items list must not be empty');
    }

    _itemInTree = HashMap<T, _NTreeNode<T>>();
    _root = _NTreeNode<T>(item: items[0], parent: null); //dummy root

    for (T item in items) {
      _NTreeNode<T> node = _NTreeNode<T>(item: item, parent: _root);

      _root!.addChild(node);

      _itemInTree[item] = node;
    }
  }


  ///
  void insertOne(T? parent, T child) {
    if (parent == null) { //Insert new root folder
      _NTreeNode<T> childNode = _NTreeNode<T>(item: child, parent: _root);

      _root!.addChild(childNode);

      _itemInTree[child] = childNode;
    } else {
      _NTreeNode<T>? parentNode = _itemInTree[parent];

      if (parentNode != null) { //Insert new subfolder
        _NTreeNode<T> childNode = _NTreeNode<T>(item: child, parent: parentNode);

        parentNode.addChild(childNode);

        _itemInTree[child] = childNode;
      } else { throw ArgumentError('The parent item does not exist in the tree'); }
    }
  }


  ///
  void insert(T parent, List<T> children) {
    _NTreeNode<T>? parentNode = _itemInTree[parent];

    if (parentNode != null) {
      for (T child in children) {
        _NTreeNode<T> node = _NTreeNode<T>(item: child, parent: parentNode);

        parentNode.addChild(node);

        _itemInTree[child] = node;
      }
    } else { throw ArgumentError('The parent item does not exist in the tree'); }
  }


  ///Update the old item in the tree with its newer version.
  void update(T oldItem, T newItem) {
    _NTreeNode<T>? node = _itemInTree[oldItem];

    if (node != null) {
      _itemInTree.remove(oldItem);

      node.item = newItem;
      _itemInTree[newItem] = node;
    } else { throw ArgumentError('The item cannot be updated, since it does not exist'); }
  }


  ///Delete an item from the tree, while also deleting its subitems.
  void delete(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      _traverseDelete(node);

      _NTreeNode<T>? parent = node.parent;
      parent!.childrenNodes.remove(node);
    } else { throw ArgumentError('The item cannot be deleted, since it does not exist'); }
  }


  ///Traverse the subtree while deleting the items from the hash map.
  void _traverseDelete(_NTreeNode<T> item) {
    _itemInTree.remove(item.item);

    if (item.childrenNodes.isNotEmpty) {
      for (_NTreeNode<T> subitem in item.childrenNodes) {
        _traverseDelete(subitem);
      }
    }
  }


  ///Get a list of all subitems. Note that the item itself it also present in the list.
  List<T> getSubitems(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      return _traverse(node, []);
    } else { throw ArgumentError('The item\'s subitems could not be accessed, since it does not exist'); }
  }


  ///Traverse.
  List<T> _traverse(_NTreeNode<T> item, List<T> items) {
    items.add(item.item);

    if (item.childrenNodes.isNotEmpty) {
      for (_NTreeNode<T> subitem in item.childrenNodes) {
        _traverse(subitem, items);
      }
    }

    return items;
  }


  ///
  bool containsChildren(T item) {
    bool containsChildren = false;

    if (_itemInTree.containsKey(item)) {
      containsChildren = _itemInTree[item]!._childrenNodes.isNotEmpty;
    }

    return containsChildren;
  }


  ///
  String getPathToItem<R>(T item, R Function(T) pathSelector) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      String path = '${pathSelector(node.item)}';

      while (node!.parent != null && node.parent!.parent != null) {
        node = node.parent;

        path = '${pathSelector(node!.item)}/$path';
      }

      return path;
    } else { throw ArgumentError('Cannot view item\'s path, since it does not exist'); }
  }


  ///
  void changeActivityStatus(T item, bool status) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      node.activity = status;
    } else { throw ArgumentError('Cannot update activity status of item, since it does not exist'); }
  }


  ///
  bool getActivityStatus(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      return node.activity;
    } else { throw ArgumentError('Cannot get activity status of item, since it does not exist'); }
  }


  ///
  List<T> getChildren(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      return node.childrenNodes.map((folder) => folder.item).toList();
    } else { throw ArgumentError('Cannot get children of item, since it does not exist'); }
  }


  ///
  T? getParent(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      if (node.parent == _root) { return null; }
      else { return node.parent!.item; }
    } else { throw ArgumentError('Cannot get parent of item, since it does not exist'); }
  }


  //GETTERS
  ///
  List<T> get getRootFolders => _root?.childrenNodes.map((rootFolder) => rootFolder.item).toList() ?? [];
}


///
class _NTreeNode<T> {
  T _item;
  final _NTreeNode<T>? _parent;
  List<_NTreeNode<T>> _childrenNodes;
  bool _activity = false;


  _NTreeNode({
    required T item,
    required _NTreeNode<T>? parent,
    List<_NTreeNode<T>>? childrenNodes
  })
    : _item = item,
      _parent = parent,
      _childrenNodes = childrenNodes ?? [];


  void addChild(_NTreeNode<T> child) {
    _childrenNodes.add(child);
  }


  //Getters
  T get item => _item;

  bool get activity => _activity;

  _NTreeNode<T>? get parent => _parent;

  List<_NTreeNode<T>> get childrenNodes => _childrenNodes;


  //Setters
  set item(T value) { _item = value; }

  set activity(bool value) { _activity = value; }

  set childrenNodes(List<_NTreeNode<T>> value) { _childrenNodes = value; }
}