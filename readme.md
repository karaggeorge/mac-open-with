# mac-open-with

> Open a file with an installed app on macOS

## Install

```
$ npm install mac-open-with
```

## Usage

```js
const openWith = require('mac-open-with');

const apps = openWith.getAppsThatOpenFile.sync('/some/file.mov');

// or

const apps = openWith.getAppsThatOpenType.sync('com.apple.quicktime-movie');

// or

const apps = openWith.getAppsThatOpenExtension.sync('mov');


// [
//     { url: 'file:///Applications/iTunes.app/', isDefault: true, icon: '...' },
//     { url: 'file:///Applications/Gifski.app/', isDefault: false, icon: '...' },
//     { url: 'file:///Applications/Kap.app/', isDefault: false, icon: '...' },
//     { url: 'file:///Applications/QuickTime%20Player.app/', isDefault: false, icon: '...' }
// ]

openWith.open('/some/file.mov', apps[0]);

// true
```


## API

### openWith

#### `App`

Object type returned by the following three methods

##### `app.url`: `string`

The url of the application

##### `app.isDefault`: `boolean`

Wether this app is the default app for that file/content type/extension

##### `app.icon`: `string`

The icon of the application `base64` encoded

#### `.getAppsThatOpenFile(filePath: string): App[]`

Get a list of app urls that can open the file type of the given file.

#### `.getAppsThatOpenType(fileType: string): App[]`

Get a list of app urls that can open the given file type

`fileType` has to be a [Uniform Type Identifier](https://en.wikipedia.org/wiki/Uniform_Type_Identifier)

#### `.getAppsThatOpenExtension(ext: string): App[]`

Get a list of app urls that can open the given extension

#### `.open(filePath: string, appUrl: string): boolean`

Open the given file with the given app url. `appUrl` needs to be one of the urls returned from `getAppsThatOpenFile` or `getAppsThatOpenType`.

Returns `true` if the file was successfully opened, `false` otherwise.
