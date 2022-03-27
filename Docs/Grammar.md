## Grammar spec (EBNF)

```
Program     ->  Decl+
Decl        ->  'type' ID '{' PropDecl (',' PropDecl)* '}'
PropDecl    ->  ID ':' PropType
PropType    ->  ID | 'string' | 'bool' | 'int' | 'float' | 'double'
```