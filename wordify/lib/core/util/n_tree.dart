import 'dart:collection';

///
class NTree<T> {
  _NTreeNode<T>? _root;
  final HashMap<T, _NTreeNode<T>> _itemInTree;


  ///
  NTree()
    : _itemInTree = HashMap<T, _NTreeNode<T>>();


  ///Set the outter most layer
  void setRoot(List<T> items) {
    if (_root == null) {
      _root = _NTreeNode<T>(item: null, parent: null); //dummy root

      for (T item in items) {
        _NTreeNode<T> node = _NTreeNode<T>(item: item, parent: _root);

        _root!.addChild(node);

        _itemInTree[item] = node;
      }
    } else { throw ArgumentError('The root is already set'); }
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
    items.add(item.item!);

    if (item.childrenNodes.isNotEmpty) {
      for (_NTreeNode<T> subitem in item.childrenNodes) {
        _traverse(subitem, items);
      }
    }

    return items;
  }


  ///
  void changeParent(T? newParent, T item) {
    _NTreeNode<T>? node = _itemInTree[item];
    _NTreeNode<T>? newParentNode = newParent != null ? _itemInTree[newParent] : _root;

    if (node != null && newParentNode != null) {
      _NTreeNode<T> parentNode = node._parent!;
      parentNode._childrenNodes.remove(node);

      node._parent = newParentNode;

      newParentNode._childrenNodes.add(node);
    } else { throw ArgumentError('Item\'s parent cannot be changed since either the item or the parent does not exist'); }
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
      String path = '${pathSelector(node.item!)}';

      while (node!.parent != null && node.parent!.parent != null) {
        node = node.parent;

        path = '${pathSelector(node!.item!)}/$path';
      }

      return path;
    } else { throw ArgumentError('Cannot view item\'s path, since it does not exist'); }
  }


  ///
  List<T> getChildren(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      return _toListItems(node.childrenNodes);
    } else { throw ArgumentError('Cannot get children of item, since it does not exist'); }
  }


  ///
  List<T> getSiblingsInclusive(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      _NTreeNode<T> parent = node.parent!;

      return _toListItems(parent.childrenNodes);
    } else { throw ArgumentError('Cannot get siblings of item, since it does not exist'); }
  }


  ///
  List<T> getSiblingsExclusive(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      _NTreeNode<T> parent = node.parent!;

      final list =  _toListItems(parent.childrenNodes);
      return list..remove(node._item);
    } else { throw ArgumentError('Cannot get siblings of item, since it does not exist'); }
  }


  ///
  T? getParent(T item) {
    _NTreeNode<T>? node = _itemInTree[item];

    if (node != null) {
      if (node.parent == _root) { return null; }
      else { return node.parent!.item; }
    } else { throw ArgumentError('Cannot get parent of item, since it does not exist'); }
  }


  ///
  List<T> _toListItems(List<_NTreeNode<T>> nodes) {
    return nodes.map((node) => node.item!).toList();
  }


  //GETTERS
  ///
  List<T> get getRootItems => _root?.childrenNodes.map((rootItem) => rootItem.item!).toList() ?? [];
}


///
class _NTreeNode<T> {
  T? _item;
  _NTreeNode<T>? _parent;
  List<_NTreeNode<T>> _childrenNodes;


  _NTreeNode({
    required T? item,
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
  T? get item => _item;

  _NTreeNode<T>? get parent => _parent;

  List<_NTreeNode<T>> get childrenNodes => _childrenNodes;


  //Setters
  set item(T? value) { _item = value; }

  set childrenNodes(List<_NTreeNode<T>> value) { _childrenNodes = value; }
}