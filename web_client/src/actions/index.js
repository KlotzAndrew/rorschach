import * as types from '../constants/actionTypes';
import portfolio from '../api/portfolio';

const setPortfolios = (portfolios) => ({
  type: types.SET_PORTFOLIOS,
  portfolios
})

export const getPortfolios = () => dispatch => {
  portfolio.getPortfolios(portfolio)
    .then(response => {
      dispatch(setPortfolios(response.data.data))
    })
}

const setStockHoldings = (assets) => ({
  type: types.SET_STOCK_HOLDINGS,
  assets
})

const setCashHoldings = (assets) => ({
  type: types.SET_CASH_HOLDINGS,
  assets
})

export const getCashTotals = (portfolioId) => dispatch => {
  portfolio.getCashTotals(portfolio)
    .then(response => {
      dispatch(setCashHoldings(response.data.data))
    })
}

export const getStockTotals = (portfolioId) => dispatch => {
  portfolio.getStockTotals(portfolio)
    .then(response => {
      dispatch(setStockHoldings(response.data.data))
    })
}

export const addTrade = (trade) => {
  return {type: types.ADD_TRADE,
  trade}
}

const setAssets = (assets) => ({
  type: types.SET_ASSETS,
  assets
})

export const getAssets = () => dispatch => {
  portfolio.getAssets()
    .then(repsonse => {
      dispatch(setAssets(repsonse.data.data))
    })
}
