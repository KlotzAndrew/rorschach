import * as types from '../constants/actionTypes';

const initialState = {
  portfolio: {},
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
    case types.SET_ASSET_TOTALS:
      return {
        ...state,
        assets: assignAssets(state.assets, action.assets)
      }
    case types.ADD_TRADE:
      return {
        ...state,
        assets: updateQuantity(state, action.trade)
      }
    default:
      return state
  }

}

function updateQuantity(state, trade) {
  let assets = Object.assign({}, state.assets)
  let asset = Object.assign({}, assets[trade.to_asset_id])
  asset.quantity += trade.quantity
  assets[asset.id] = asset
  return assets
}

function assignAssets(state_assets, new_assets) {
  let assets = Object.assign({}, state_assets)
  new_assets.forEach(function(asset) {
    assets[asset.id] = asset
  })
  return assets
};

export default portfolios;
