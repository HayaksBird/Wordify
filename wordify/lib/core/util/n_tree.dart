import 'dart:collection';

///
class NTree<T> {
  late final NTreeNode<T>? _root;
  late final HashMap<T, NTreeNode<T>> itemInTree;


  ///Set the outter most layer
  void setRoot(List<T> items) {
    if (items.isEmpty) {
      throw ArgumentError('Items list must not be empty');
    }

    itemInTree = HashMap<T, NTreeNode<T>>();
    _root = NTreeNode<T>(item: items[0], parent: null); //dummy root

    for (T item in items) {
      NTreeNode<T> node = NTreeNode<T>(item: item, parent: _root);

      _root!.addChild(node);

      itemInTree[item] = node;
    }
  }


  ///
  void insertOne(T? parent, T child) {
    if (parent == null) { //Insert new root folder
      NTreeNode<T> childNode = NTreeNode<T>(item: child, parent: _root);

      _root!.addChild(childNode);

      itemInTree[child] = childNode;
    } else {
      NTreeNode<T>? parentNode = itemInTree[parent];

      if (parentNode != null) { //Insert new subfolder
        NTreeNode<T> childNode = NTreeNode<T>(item: child, parent: parentNode);

        parentNode.addChild(childNode);

        itemInTree[child] = childNode;
      } else { throw ArgumentError('The parent item does not exist in the tree'); }
    }
  }


  ///
  void insert(T parent, List<T> children) {
    NTreeNode<T>? parentNode = itemInTree[parent];

    if (parentNode != null) {
      for (T child in children) {
        NTreeNode<T> node = NTreeNode<T>(item: child, parent: parentNode);

        parentNode.addChild(node);

        itemInTree[child] = node;
      }
    } else { throw ArgumentError('The parent item does not exist in the tree'); }
  }


  ///Update the old item in the tree with its newer version.
  void update(T oldItem, T newItem) {
    NTreeNode<T>? node = itemInTree[oldItem];

    if (node != null) {
      itemInTree.remove(oldItem);

      node.item = newItem;
      itemInTree[newItem] = node;
    } else { throw ArgumentError('The item cannot be updated, since it does not exist'); }
  }


  ///Delete an item from the tree, while also deleting its subitems.
  void delete(T item) {
    NTreeNode<T>? node = itemInTree[item];

    if (node != null) {
      _traverseDelete(node);

      NTreeNode<T>? parent = node.parent;
      parent!.childrenNodes.remove(node);
    } else { throw ArgumentError('The item cannot be deleted, since it does not exist'); }
  }


  ///Traverse the subtree while deleting the items from the hash map.
  void _traverseDelete(NTreeNode<T> item) {
    itemInTree.remove(item.item);

    if (item.childrenNodes.isNotEmpty) {
      for (NTreeNode<T> subitem in item.childrenNodes) {
        _traverseDelete(subitem);
      }
    }
  }


  ///Get a list of all subitems. Note that the item itself it also present in the list.
  List<T> getSubitems(T item) {
    NTreeNode<T>? node = itemInTree[item];

    if (node != null) {
      return _traverse(node, []);
    } else { throw ArgumentError('The item\'s subitems could not be accessed, since it does not exist'); }
  }


  ///Traverse.
  List<T> _traverse(NTreeNode<T> item, List<T> items) {
    items.add(item.item);

    if (item.childrenNodes.isNotEmpty) {
      for (NTreeNode<T> subitem in item.childrenNodes) {
        _traverse(subitem, items);
      }
    }

    return items;
  }


  ///
  bool containsChildren(T item) {
    bool containsChildren = false;

    if (itemInTree.containsKey(item)) {
      containsChildren = itemInTree[item]!._childrenNodes.isNotEmpty;
    }

    return containsChildren;
  }


  ///
  String getPathToItem<R>(T item, R Function(T) pathSelector) {
    NTreeNode<T>? node = itemInTree[item];

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
    NTreeNode<T>? node = itemInTree[item];

    if (node != null) {
      node.activity = status;
    } else { throw ArgumentError('Cannot update activity status of item, since it does not exist'); }
  }


  ///
  bool getActivityStatus(T item) {
    NTreeNode<T>? node = itemInTree[item];

    if (node != null) {
      return node.activity;
    } else { throw ArgumentError('Cannot get activity status of item, since it does not exist'); }
  }


  //GETTERS
  ///
  List<NTreeNode<T>> get getRootFolders => _root?.childrenNodes ?? [];
}


///
class NTreeNode<T> {
  T _item;
  final NTreeNode<T>? _parent;
  List<NTreeNode<T>> _childrenNodes;
  bool _activity = false;


  NTreeNode({
    required T item,
    required NTreeNode<T>? parent,
    List<NTreeNode<T>>? childrenNodes
  })
    : _item = item,
      _parent = parent,
      _childrenNodes = childrenNodes ?? [];


  void addChild(NTreeNode<T> child) {
    _childrenNodes.add(child);
  }


  //Getters
  T get item => _item;

  bool get activity => _activity;

  NTreeNode<T>? get parent => _parent;

  List<NTreeNode<T>> get childrenNodes => _childrenNodes;


  //Setters
  set item(T value) { _item = value; }

  set activity(bool value) { _activity = value; }

  set childrenNodes(List<NTreeNode<T>> value) { _childrenNodes = value; }
}