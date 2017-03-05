import * as types from '../constants/actionTypes';

const initialState = {
  portfolio: {},
  assets: {}
}

const portfolios = (state = initialState, action) => {
  switch (action.type) {
    case types.SET_PORTFOLIO:
      return {
        ...state,
        portfolio: action.portfolio
      }
    case types.SET_ASSET_TOTALS:
      let new_state = Object.assign({}, state)
      action.assets.forEach(function(asset) {
        new_state.assets[asset.id] = asset
      })
      return {
        ...state,
        assets: assignAssets(state.assets, action.assets)
      }
    default:
      return state
  }

}

function assignAssets(state_assets, new_assets) {
  new_assets.forEach(function(asset) {
    state_assets[asset.id] = asset
  })
  return state_assets
};

export default portfolios;
