# mac-open-with

> Open a file with an installed app on macOS

Requires macOS 10.12 or later. macOS 10.13 or earlier needs to download the [Swift runtime support libraries](https://download.developer.apple.com/Developer_Tools/Swift_5_Runtime_Support_for_Command_Line_Tools/Swift_5_Runtime_Support_for_Command_Line_Tools.dmg).

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

Object type returned by the following three methods.

##### `app.url`: `string`

The URL of the app.

##### `app.isDefault`: `boolean`

Whether this app is the default app for that file/content type/extension.

##### `app.icon`: `string`

The icon of the app `base64` encoded.

#### `.getAppsThatOpenFile(filePath: string): App[]`

Get a list of app URLs that can open the file type of the given file.

#### `.getAppsThatOpenType(fileType: string): App[]`

Get a list of app URLs that can open the given file type.

`fileType` has to be a [Uniform Type Identifier](https://en.wikipedia.org/wiki/Uniform_Type_Identifier)

#### `.getAppsThatOpenExtension(ext: string): App[]`

Get a list of app URLs that can open the given file extension.

#### `.open(filePath: string, appUrl: string): boolean`

Open the given file with the given app URL. `appUrl` needs to be one of the URLs returned from `getAppsThatOpenFile` or `getAppsThatOpenType`.

Returns `true` if the file was successfully opened, `false` otherwise.
