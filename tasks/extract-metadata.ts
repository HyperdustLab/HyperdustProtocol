import { task } from 'hardhat/config'

const fs = require('fs')
const path = require('path')

task('extract-metadata', 'Extracts and modifies metadata from build info')
  .addParam('contractPath', 'The path to the contract')
  .addParam('contractName', 'The name of the contract')
  .setAction(async taskArgs => {
    const { contractPath, contractName } = taskArgs

    console.info(__dirname)

    const buildInfoPath = path.join(__dirname, '../artifacts/build-info')

    const buildFiles = fs.readdirSync(buildInfoPath)

    const buildFilePath = path.join(buildInfoPath, buildFiles[buildFiles.length - 1])
    const buildFile = fs.readFileSync(buildFilePath, 'utf8')

    const buildJson = JSON.parse(buildFile)

    const metadata = buildJson.output.contracts[contractPath][contractName].metadata

    const metadataObject = JSON.parse(metadata)

    delete metadataObject.license

    const updatedMetadata = JSON.stringify(metadataObject, null, 2)

    const outputFilePath = path.join(__dirname, '../jsonInputs/', contractName + '.json')
    fs.writeFileSync(outputFilePath, updatedMetadata, 'utf8')
    console.log('Metadata saved to metadata.json')
  })

module.exports = {}
