import * as types from '../constants/actionTypes';
import portfolio from '../api/portfolio';

const setPortfolio = (portfolio) => ({
  type: types.SET_PORTFOLIO,
  portfolio
})

export const getPortfolio = () => dispatch => {
  portfolio.getPortfolio(portfolio)
    .then(response => {
      dispatch(setPortfolio(response.data.data))
    })
}

const setAssetTotals = (assets) => ({
  type: types.SET_ASSET_TOTALS,
  assets
})

export const getCashTotals = (portfolioId) => dispatch => {
  portfolio.getCashTotals(portfolio)
    .then(response => {
      dispatch(setAssetTotals(response.data.data))
    })
}

export const getStockTotals = (portfolioId) => dispatch => {
  portfolio.getStockTotals(portfolio)
    .then(response => {
      dispatch(setAssetTotals(response.data.data))
    })
}

export const addTrade = (trade) => {
  return {type: types.ADD_TRADE,
  trade}
}
