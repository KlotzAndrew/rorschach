import * as types from '../constants/actionTypes';

const initialState = {
  portfolio: {},
  assets: {},
  cash_assets: {},
}

const portfolios = (state = initialState, action) => {
  console.log('action', action)
  switch (action.type) {
    case types.SET_PORTFOLIO:
      return {
        ...state,
        portfolio: action.portfolio
      }
    case types.SET_ASSET_TOTALS:
      return {
        ...state,
        assets: assignAssets(state.assets, action.assets)
      }
    case types.SET_CASH_TOTALS:
      return {
        ...state,
        cash_assets: assignAssets(state.cash_assets, action.assets)
      }
    case types.ADD_TRADE:
      return {
        ...state,
        assets: updateAssetQuantity(state, action.trade),
        cash_assets: updateCashQuantity(state, action.trade)
      }
    default:
      return state
  }

}

function updateCashQuantity(state, trade) {
  let assets = Object.assign({}, state.cash_assets)
  let asset = Object.assign({}, assets[trade.cash_id])
  asset.quantity += parseFloat(trade.cash_total)
  assets[asset.id] = asset
  return assets
}

function updateAssetQuantity(state, trade) {
  let assets = Object.assign({}, state.assets)
  let asset = Object.assign({}, assets[trade.asset_id])
  asset.quantity += trade.quantity
  assets[asset.id] = asset
  return assets
}

function assignAssets(state_assets, new_assets) {
  let assets = Object.assign({}, state_assets)
  new_assets.forEach(function(asset) {
    asset.quantity = parseFloat(asset.quantity)
    assets[asset.id] = asset
  })
  return assets
};

export default portfolios;
