# mac-open-with

> Open a file with an installed app on macOS

## Install

```
$ npm install mac-open-with
```

## Usage

```js
const openWith = require('mac-open-with');

const apps = openWith.getAppsThatOpenFile('/some/file.mov');

// or

const apps = openWith.getAppsThatOpenType('com.apple.quicktime-movie');


// [
//   'file:///Applications/iTunes.app/',
//   'file:///Applications/Gifski.app/',
//   'file:///Applications/QuickTime%20Player.app/',
//   'file:///Applications/Kap.app/'
// ]

openWith.open('/some/file.mov', apps[0]);

// true
```


## API

### openWith

#### `.getAppsThatOpenFile(filePath: string): string[]`

Get a list of app urls that can open the file type of the given file.

#### `.getAppsThatOpenType(fileType: string): string[]`

Get a list of app urls that can open the given file type

`fileType` has to be a [Uniform Type Identifier](https://en.wikipedia.org/wiki/Uniform_Type_Identifier)

#### `.open(filePath: string, appUrl: string): boolean`

Open the given file with the given app url. `appUrl` needs to be one of the urls returned from `getAppsThatOpenFile` or `getAppsThatOpenType`.

Returns `true` if the file was successfully opened, `false` otherwise.
