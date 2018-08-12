import Web3 from 'web3'
import TruffleContract from 'truffle-contract'
import JSONData from './build/contracts/FeelGood.json'

// const web3ForEvent = new Web3(new Web3.providers.HttpProvider('https://5edad685.ngrok.io'))
// const uri = window.prompt('Provider?')
const uri = 'http://localhost:8545'
const web3ForEvent = new Web3(new Web3.providers.HttpProvider(uri))
window.web3ForEvent = web3ForEvent

export const getContract = provider => {
  const Contract = TruffleContract(JSONData)
  Contract.setProvider(provider)
  Contract.defaults({ gas: 500000 })
  // FIXME: https://github.com/trufflesuite/truffle-contract/issues/56#issuecomment-331084530
  if (typeof Contract.currentProvider.sendAsync !== 'function') {
    Contract.currentProvider.sendAsync = function () {
      return Contract.currentProvider.send.apply(
        Contract.currentProvider, arguments
      )
    }
  }
  return Contract
}

const DocAuthEvent = getContract(web3ForEvent.currentProvider)

export const getByID = id => DocAuthEvent.deployed().then(i => i.donors(id))

export const onStage1Event = callback => DocAuthEvent.deployed()
  .then(i => i.DonorCreatedEvent({}, { fromBlock: 0, toBlock: 'latest' })
    .watch((err, ev) => {
      if (!err) {
        callback(ev.args)
      }
    })
  )

export const onStage2Event = callback => DocAuthEvent.deployed()
  .then(i => i.IsTestedEvent({}, { fromBlock: 0, toBlock: 'latest' })
    .watch((err, ev) => {
      if (!err) {
        callback(ev.args)
      }
    })
  )

export const onStage3Event = callback => DocAuthEvent.deployed()
  .then(i => i.IsConsumedEvent({}, { fromBlock: 0, toBlock: 'latest' })
    .watch((err, ev) => {
      if (!err) {
        callback(ev.args)
      }
    })
  )
