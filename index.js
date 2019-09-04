'use strict'
const path = require('path');
const execa = require('execa');
const childProcess = require('child_process');
const electronUtil = require('electron-util/node');

const binary = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'open-with');

exports.getAppsThatOpenFile = filePath => {
  try {
    const {stdout} = execa.sync(binary, ['apps-for-file', path.resolve(filePath)]);
    return JSON.parse(stdout);
  } catch {
    return [];
  }
}

exports.getAppsThatOpenType = fileType => {
  try {
    const {stdout} = execa.sync(binary, ['apps-for-type', fileType]);
    return JSON.parse(stdout);
  } catch {
    return [];
  }
}

exports.openFileWithApp = (filePath, appUrl) => {
  try {
    execa.sync(binary, ['open', filePath, appUrl]);
    return true;
  } catch {
    return false;
  }
}

