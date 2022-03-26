# jsonsc
A DSL to define JSON schema

## Getting started

### Sample input
File `hello.jsons`

```ruby
type Foo {
    name: string,
    count: int,
    price: decimal,
    is_active: bool
}

type Bar {
    foo: Foo
}
```

### Run command-line tool

```shell
OVERVIEW: A DSL to define JSON schema

USAGE: jsonsc <path> [--verbose]

ARGUMENTS:
  <path>                  Path to .jsons file

OPTIONS:
  --verbose               Enable verbose logging
  -h, --help              Show help information.
```

- Execute: `jsonsc hello.jsons`


## Build
- Build debug `swift build`
- Run debug: `swift run`
- Run tests: `swift tests`
- Build release: `swift build -c release`