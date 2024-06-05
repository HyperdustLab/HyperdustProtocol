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
    let latestFile = null
    let latestMtime = 0

    // Find the latest modified file
    for (const file of buildFiles) {
      const filePath = path.join(buildInfoPath, file)
      const stats = fs.statSync(filePath)
      if (stats.mtimeMs > latestMtime) {
        latestMtime = stats.mtimeMs
        latestFile = filePath
      }
    }

    if (latestFile) {
      const buildFile = fs.readFileSync(latestFile, 'utf8')
      const buildJson = JSON.parse(buildFile)

      let metadataObject = null
      if (buildJson.output.contracts && buildJson.output.contracts[contractPath] && buildJson.output.contracts[contractPath][contractName]) {
        const metadata = buildJson.output.contracts[contractPath][contractName].metadata
        metadataObject = JSON.parse(metadata)
      }

      if (metadataObject) {
        // for (const key in metadataObject.sources) {
        //   console.info(key)

        //   delete metadataObject.sources[key].license
        // }

        delete metadataObject.license

        const updatedMetadata = JSON.stringify(metadataObject, null, 2)

        const outputFilePath = path.join(__dirname, '../jsonInputs/', contractName + '.json')
        fs.writeFileSync(outputFilePath, updatedMetadata, 'utf8')
        console.log('Metadata saved to metadata.json')
      } else {
        console.log(`Metadata for ${contractName} not found in the latest build file.`)
      }
    } else {
      console.log('No build files found.')
    }
  })

module.exports = {}
