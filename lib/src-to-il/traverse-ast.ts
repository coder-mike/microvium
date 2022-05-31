import { unexpected } from '../utils';
import { compileError, compileErrorIfReachable, SourceCursor, visitingNode } from './common';
import * as B from './supported-babel-types';

/*
 * I tried using `@babel/traverse` but I find that the type signatures are not
 * strong enough to do what I want to do, and it seemed not to give much control
 * over whether to iterate deeper or not at any particular node. This
 * `traverseAST` function is my solution. It's a function which simply calls the
 * callback for each child of the given node. It's not recursive -- it requires
 * that the callback call traverseAST if it wishes to traverse deeper. This
 * gives full control to the callback about when to traverse vs when to override
 * the traversal with custom behavior.
 *
 * The intended way to use this is for the callback to be a function with a
 * switch statement to define special handling for chosen node types, and then a
 * `default` path that calls traverseAST.
 *
 * The cursor is just used for reporting errors.
 *
 * Note: In the case of identifiers, this function only calls `f` if the
 * identifier is a variable reference. For example, in the member expression
 * `o.p`, `o` is a variable reference, but `p` is not. In `var v`, `v` is not a
 * variable reference -- it is considered part of the variable declaration. The
 * reason for this is so that the tag `Identifier` does not need context to
 * understand.
 */
export function traverseChildren<TContext = unknown>(
  cur: SourceCursor,
  node: B.Node,
  callback: (node: B.Node, context?: TContext) => void,
  context?: TContext,
) {
  visitingNode(cur, node);
  const f = (n: B.Node) => {
    visitingNode(cur, n);
    callback(n, context);
    visitingNode(cur, node); // Back to parent
  }

  const n = node as B.SupportedNode;
  switch (n.type) {
    case 'ArrayExpression': return n.elements.forEach(e => e && f(e));
    case 'AssignmentExpression': return f(n.left), f(n.right);
    case 'BinaryExpression': return f(n.left), f(n.right);
    case 'BlockStatement': return n.body.forEach(f);
    case 'CallExpression': return f(n.callee), n.arguments.forEach(f);
    case 'ConditionalExpression': return f(n.test), f(n.consequent), f(n.alternate);
    case 'DoWhileStatement': return f(n.test), f(n.body);
    case 'ExpressionStatement': return f(n.expression);
    case 'ForStatement': return n.init && f(n.init), n.test && f(n.test), n.update && f(n.update), f(n.body);
    case 'IfStatement': return f(n.test), f(n.consequent), n.alternate && f(n.alternate);
    case 'LogicalExpression': return f(n.left), f(n.right);
    case 'ObjectExpression': return n.properties.forEach(f);
    case 'Program': return n.body.forEach(f);
    case 'ReturnStatement': return n.argument && f(n.argument);
    case 'ThrowStatement': return n.argument && f(n.argument);
    case 'UnaryExpression': return f(n.argument);
    case 'UpdateExpression': return f(n.argument);
    case 'VariableDeclaration': return n.declarations.forEach(f);
    case 'WhileStatement': return f(n.test), f(n.body);
    case 'ExportNamedDeclaration': return f(n.declaration ?? unexpected());
    case 'ObjectProperty': return (n.computed ? f(n.key) : undefined), f(n.value);
    case 'TemplateLiteral': return n.expressions.forEach(f);

    case 'ImportDeclaration': return;
    case 'Identifier': return;
    case 'StringLiteral': return;
    case 'ThisExpression': return;
    case 'BooleanLiteral': return;
    case 'NullLiteral': return;
    case 'NumericLiteral': return;
    case 'BreakStatement': return;

    case 'SwitchStatement': {
      f(n.discriminant);
      for (const { test, consequent } of n.cases) {
        test && f(test);
        consequent.forEach(f);
      }
      break;
    }

    case 'MemberExpression': {
      f(n.object);
      // Note: if the member access is of the form `o.p` then `p` here is not
      // iterated because the identifier `p` is in the scope of `o`. In the case
      // of `o[p]`, `p` is a variable reference to the corresponding variable in
      // the scope that the expression is executing.
      if (n.computed) {
        f(n.property)
      }
      return;
    }

    case 'VariableDeclarator': {
      // Note: variable IDs are intentionally not iterated, because contexts that
      // use the ID will not be looking to visit "Identifier" nodes but rather
      // just "VariableDeclarator" nodes.
      n.init && f(n.init);
      return;
    }

    case 'ArrowFunctionExpression':
    case 'FunctionExpression':
    case 'FunctionDeclaration': {
      for (const param of n.params) {
        if (param.type !== 'Identifier') {
          // Note: for non-identifier parameters, we would need to recurse on
          // the initializers, but no the identifiers (for the same reason as noted above for VariableDeclarator)
          return compileError(cur, 'Not supported');
        }
      }
      return f(n.body);
    }

    default:
      compileErrorIfReachable(cur, n);
  }
}

let context: undefined;
