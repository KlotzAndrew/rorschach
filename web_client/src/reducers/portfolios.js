import * as types from '../constants/actionTypes';
import R from 'ramda';

const initialState = {
  portfolio: {},
  stock_holdings: {},
  cash_holdings: {},
  assets: {},
  trade: []
}

const portfolios = (state = initialState, action) => {
  console.log('action', action)
  switch (action.type) {
    case types.SET_PORTFOLIOS:
      return {
        ...state,
        portfolios: assignPortfolios(state.portfolios, action.portfolios)
      }
    case types.SET_ASSETS:
      return {
        ...state,
        assets: assignAssetNormalized(state.assets, action.assets)
      }
    case types.SET_STOCK_HOLDINGS:
      return {
        ...state,
        stock_holdings: assignAssets(state.stock_holdings, action.assets, action.portfolioId)
      }
    case types.SET_CASH_HOLDINGS:
      return {
        ...state,
        cash_holdings: assignAssets(state.cash_holdings, action.assets, action.portfolioId)
      }
    case types.ADD_TRADE:
      return {
        ...state,
        stock_holdings: updateAssetQuantity(state, action.trade),
        cash_holdings: updateCashQuantity(state, action.trade),
        trades: R.append(action.trade, state.trades)
      }
    case types.SET_TRADES:
      return {
        ...state,
        trades: R.clone(action.trades)
      }
    default:
      return state
  }
}

function assignPortfolios(state_portfolios, new_portfolios) {
  let portfolios = Object.assign({}, state_portfolios);
  new_portfolios.forEach(function(port) { portfolios[port.id] = port.attributes })
  return portfolios
}

// TODO: nested attrs are ugly, immutable?
function updateCashQuantity(state, trade) {
  let assets = Object.assign({}, state.cash_holdings)
  let port_assets = Object.assign({}, assets[trade.portfolio_id])
  let asset = Object.assign({}, port_assets[trade.cash_id])
  asset.quantity += parseFloat(trade.cash_total)

  port_assets[trade.cash_id] = asset
  assets[trade.portfolio_id] = port_assets
  return assets
}

function updateAssetQuantity(state, trade) {
  let assets = Object.assign({}, state.stock_holdings)
  let port_assets = Object.assign({}, assets[trade.portfolio_id])
  let asset = Object.assign({}, port_assets[trade.asset_id])
  asset.quantity += trade.quantity
  asset.price = parseFloat(trade.price)

  port_assets[trade.asset_id] = asset
  assets[trade.portfolio_id] = port_assets
  return assets
}

function assignAssets(state_assets, new_assets, portfolioId) {
  let assets = Object.assign({}, state_assets)
  let port_asset = Object.assign({}, assets[portfolioId])

  assignAssetNormalized(port_asset, new_assets)

  assets[portfolioId] = port_asset
  return assets
};

function assignAssetNormalized(base, assets) {
  assets.forEach(function(asset) {
    asset.quantity = parseFloat(asset.quantity)
    base[asset.id] = asset
  })
  return base
}

export default portfolios;
