import * as types from '../constants/actionTypes';

const initialState = {
  portfolio: {},
  stock_holdings: {},
  cash_holdings: {},
  assets: {}
}

const portfolios = (state = initialState, action) => {
  console.log('action', action)
  switch (action.type) {
    case types.SET_PORTFOLIO:
      return {
        ...state,
        portfolio: action.portfolio
      }
    case types.SET_ASSETS:
      return {
        ...state,
        assets: assignAssets(state.assets, action.assets)
      }
    case types.SET_STOCK_HOLDINGS:
      return {
        ...state,
        stock_holdings: assignAssets(state.stock_holdings, action.assets)
      }
    case types.SET_CASH_HOLDINGS:
      return {
        ...state,
        cash_holdings: assignAssets(state.cash_holdings, action.assets)
      }
    case types.ADD_TRADE:
      return {
        ...state,
        stock_holdings: updateAssetQuantity(state, action.trade),
        cash_holdings: updateCashQuantity(state, action.trade)
      }
    default:
      return state
  }

}

function updateCashQuantity(state, trade) {
  let assets = Object.assign({}, state.cash_holdings)
  let asset = Object.assign({}, assets[trade.cash_id])
  asset.quantity += parseFloat(trade.cash_total)
  assets[asset.id] = asset
  return assets
}

function updateAssetQuantity(state, trade) {
  let assets = Object.assign({}, state.stock_holdings)
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
