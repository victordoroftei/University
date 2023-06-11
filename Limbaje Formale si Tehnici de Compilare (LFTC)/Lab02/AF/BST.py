class Node:
    def __init__(self, value, code):
        self.value = str(value)
        self.code = code
        self.left = None
        self.right = None

    def __str__(self):
        return f"({self.value}; {self.code})"


def insertValue(root, value, code):
    if root is None:
        return Node(value, code)

    else:
        if root.value == value:
            return root
        elif value > root.value:
            root.right = insertValue(root.right, value, code)
        else:
            root.left = insertValue(root.left, value, code)
    return root


def searchValue(root, value):
    if root is None or root.value == value:
        return root

    if value > root.value:
        return searchValue(root.right, value)

    return searchValue(root.left, value)


def inorderTraversal(root):
    if root is not None:
        inorderTraversal(root.left)
        print(root)
        inorderTraversal(root.right)
