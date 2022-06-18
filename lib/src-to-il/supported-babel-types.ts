/*
I haven't implemented support for all babel types (all JS syntax), so this file
exports the supported subset.
*/

import * as B from '@babel/types';

export {
  ArrayExpression,
  ArrowFunctionExpression,
  AssignmentExpression,
  BinaryExpression,
  Block,
  BlockStatement,
  BreakStatement,
  CallExpression,
  ConditionalExpression,
  DoWhileStatement,
  ExportNamedDeclaration,
  Expression,
  ExpressionStatement,
  File,
  ForStatement,
  FunctionDeclaration,
  FunctionExpression,
  Identifier,
  IfStatement,
  ImportDeclaration,
  ImportDefaultSpecifier,
  ImportNamespaceSpecifier,
  ImportSpecifier,
  isExpression,
  isTSType,
  LogicalExpression,
  LVal,
  MemberExpression,
  Node,
  ObjectExpression,
  PrivateName,
  Program,
  ReturnStatement,
  Statement,
  SwitchStatement,
  TemplateLiteral,
  ThisExpression,
  ThrowStatement,
  TryStatement,
  UnaryExpression,
  UpdateExpression,
  VariableDeclaration,
  VariableDeclarator,
  WhileStatement,
} from '@babel/types';

export type SupportedStatement =
  | B.IfStatement
  | B.BlockStatement
  | B.ExpressionStatement
  | B.WhileStatement
  | B.DoWhileStatement
  | B.VariableDeclaration
  | B.ForStatement
  | B.ReturnStatement
  | B.ThrowStatement
  | B.ExportNamedDeclaration
  | B.SwitchStatement
  | B.BreakStatement
  | B.FunctionDeclaration
  | B.TryStatement
  | SupportedLoopStatement

export type SupportedLoopStatement =
  | B.WhileStatement
  | B.DoWhileStatement
  | B.ForStatement

export type SupportedFunctionExpression =
  | B.FunctionExpression
  | B.ArrowFunctionExpression

export type SupportedFunctionNode =
  | B.FunctionDeclaration
  | SupportedFunctionExpression

export type SupportedModuleStatement =
  | SupportedStatement
  | B.ImportDeclaration

export type SupportedExpression =
  | B.BooleanLiteral
  | B.NumericLiteral
  | B.StringLiteral
  | B.NullLiteral
  | B.Identifier
  | B.BinaryExpression
  | B.UpdateExpression
  | B.UnaryExpression
  | B.AssignmentExpression
  | B.LogicalExpression
  | B.CallExpression
  | B.MemberExpression
  | B.ArrayExpression
  | B.ObjectExpression
  | B.ConditionalExpression
  | B.ThisExpression
  | B.TemplateLiteral
  | SupportedFunctionExpression

export type SupportedNode =
  | B.Program
  | B.VariableDeclarator
  | B.ObjectProperty
  | B.CatchClause
  | SupportedModuleStatement
  | SupportedExpression

export function isFunctionNode(node: SupportedNode): node is SupportedFunctionNode {
  return node.type === 'FunctionDeclaration'
    || node.type === 'ArrowFunctionExpression';
}
