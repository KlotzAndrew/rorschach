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

const setTrades = trades => ({
  type: types.SET_TRADES,
  trades
})

export const getTrades = () => dispatch => {
  portfolio.getTrades()
    .then(response => {
      dispatch(setTrades(response.data.data))
    })
}

const setStockHoldings = (portfolioId, assets) => ({
  type: types.SET_STOCK_HOLDINGS,
  portfolioId,
  assets
})

const setCashHoldings = (portfolioId, assets) => ({
  type: types.SET_CASH_HOLDINGS,
  portfolioId,
  assets
})

export const getCashHoldings = (portfolioId) => dispatch => {
  portfolio.getCashHoldings(portfolioId)
    .then(response => {
      dispatch(setCashHoldings(portfolioId, response.data.data))
    })
}

export const getStockHoldings = (portfolioId) => dispatch => {
  portfolio.getStockHoldings(portfolioId)
    .then(response => {
      dispatch(setStockHoldings(portfolioId, response.data.data))
    })
}


const setTradeSignals = (portfolioId, signals) => {
  return {
    type: types.SET_TRADE_SIGNALS,
    portfolioId,
    signals
  }
}

export const getTradeSignals = portfolioId => dispatch => {
  portfolio.getTradeSignals(portfolioId)
    .then(repsonse => {
      dispatch(setTradeSignals(portfolioId, repsonse.data.data))
    })
}

export const addTrade = trade => {
  return {type: types.ADD_TRADE,
  trade}
}

export const addTick = tick => {
  return {
    type: types.ADD_TICK,
    tick
  }
}

const setAssets = assets => ({
  type: types.SET_ASSETS,
  assets
})

export const getAssets = () => dispatch => {
  portfolio.getAssets()
    .then(repsonse => {
      dispatch(setAssets(repsonse.data.data))
    })
}
