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

export const getAssetTotals = (portfolioId) => dispatch => {
  portfolio.getAssetTotals(portfolio)
    .then(response => {
      dispatch(setAssetTotals(response.data.data))
    })
}
