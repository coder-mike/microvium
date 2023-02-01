import { assertUnreachable, notImplemented, unexpected } from '../../utils';
import { SourceCursor } from '../common';
import * as B from '../supported-babel-types';
import { traverseChildren } from '../traverse-ast';

// Stack depths for each node in the AST.
export type AstRelativeStackDepths = WeakMap<B.SupportedNode,
  | number // Stack depth relative to parent node
  | 'na' // Stack depth of this node doesn't make sense relative to parent
  | undefined // Microvium hasn't yet implemented the stack depth calc for this node
>

/**
 * Microvium saves the stack temporaries to the closure at `await` points in an
 * async function. This function calculates the stack depth corresponding to the
 * *start* of each node in the AST.
 */
export function awaitStackDepthCalc(func: B.SupportedFunctionNode): WeakMap<B.Node, number> {
  const result = new WeakMap<B.Node, number>();

  // The stack depth at the root of an async function includes the synchronous
  // return value followed by 2 words for the root catch block
  const rootDepth = func.async ? 3 : unexpected();
  inner(func.body, rootDepth);

  function inner(node: B.Node, depth: number) {
    result.set(node, depth);
    for (const [child, relativeDepth] of stackDepthOfChildrenRelativeToParent(node)) {
      inner(child, depth + relativeDepth)
    }
  }

  return result;
}

function stackDepthOfChildrenRelativeToParent(node_: B.Node):
  | number // stack depth of each child relative to parent
  | [B.Node, number][] // stack depth of individual children relative to parent
  | 'dont-enumerate-children' // stack doesn't carry through to child
  | undefined // we have no measurement yet
{
  const node = node_ as B.SupportedNode;

  switch (node.type) {
    case 'ArrayExpression': return 3;
    case 'ArrowFunctionExpression': return 'dont-enumerate-children';
    case 'AssignmentExpression':
      if (node.operator === '=') return [[node.right, 0]];
      else return [[node.right, 1]];

    case 'AwaitExpression':
    case 'BinaryExpression':
    case 'BlockStatement':
    case 'BooleanLiteral':
    case 'BreakStatement':
    case 'CallExpression':
    case 'CatchClause':
    case 'ClassDeclaration':
    case 'ClassExpression':
    case 'ClassMethod':
    case 'ClassProperty':
    case 'ConditionalExpression':
    case 'DoWhileStatement':
    case 'ExportNamedDeclaration':
    case 'ExpressionStatement':
    case 'ForStatement':
    case 'FunctionDeclaration':
    case 'FunctionExpression':
    case 'Identifier':
    case 'IfStatement':
    case 'ImportDeclaration':
    case 'LogicalExpression':
    case 'MemberExpression':
    case 'NewExpression':
    case 'NullLiteral':
    case 'NumericLiteral':
    case 'ObjectExpression':
    case 'ObjectProperty':
    case 'Program':
    case 'ReturnStatement':
    case 'StringLiteral':
    case 'SwitchStatement':
    case 'TemplateLiteral':
    case 'ThisExpression':
    case 'ThrowStatement':
    case 'TryStatement':
    case 'UnaryExpression':
    case 'UpdateExpression':
    case 'VariableDeclaration':
    case 'VariableDeclarator':
    case 'WhileStatement':
    default:
      // WIP
      return undefined;
      //assertUnreachable(node);
  }
}

export function calcStackDepthsForAst(cur: SourceCursor, root: B.SupportedNode): {
  stackDepthRelativeToParent: AstRelativeStackDepths,
  parentOfNode: WeakMap<B.SupportedNode, B.SupportedNode | 'none'>,
} {
  const stackDepthRelativeToParent: AstRelativeStackDepths = new WeakMap();
  const parentOfNode = new WeakMap<B.SupportedNode, B.SupportedNode | 'none'>();

  inner(root, 'none');

  function inner(node_: B.Node, parent: B.SupportedNode | 'none') {
    const node = node_ as B.SupportedNode;

    parentOfNode.set(node, parent);
    const children = stackDepthOfChildrenRelativeToParent(node);

    let context: any;
    if (children === 'dont-enumerate-children') {
      context = { type: 'dont-enumerate-children' }
    } else if (typeof children === 'number') {
      context = { type: 'number' }
    }

    traverseChildren(cur, node, inner, node);
  }

  return { stackDepthRelativeToParent, parentOfNode };
}