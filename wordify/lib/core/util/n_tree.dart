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


  ///
  void update(T oldItem, T newItem) {
    NTreeNode<T>? node = itemInTree[oldItem];

    if (node != null) {
      node.item = newItem;
    } else { throw ArgumentError('The item cannot be updated, since it does not exist'); }
  }


  ///
  void deleteChildren(T item) {
    NTreeNode<T>? node = itemInTree[item];

    if (node != null) {
      node.childrenNodes = [];
    } else { throw ArgumentError('The item cannot be deleted, since it does not exist'); }
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
  List<NTreeNode<T>> get getRootFolders => _root?.childrenNodes ?? [];
}


///
class NTreeNode<T> {
  T _item;
  final NTreeNode<T>? _parent;
  List<NTreeNode<T>> _childrenNodes;


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

  NTreeNode<T>? get parent => _parent;

  List<NTreeNode<T>> get childrenNodes => _childrenNodes;


  //Setters
  set item(T value) { _item = value; }

  set childrenNodes(List<NTreeNode<T>> value) { _childrenNodes = value; }
}