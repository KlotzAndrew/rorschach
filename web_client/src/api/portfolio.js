import axiosInstance from '../config/axios';

export default{
  getPortfolios() {
    return axiosInstance.get('portfolios');
  },

  getAssets() {
    return axiosInstance.get('assets');
  },

  getTrades() {
    return axiosInstance.get('trades');
  },

  getCashHoldings(portfolio_id) {
    return axiosInstance.get(`trades/cash_holdings/${portfolio_id}`);
  },

  getStockHoldings(portfolio_id) {
    return axiosInstance.get(`trades/stock_holdings/${portfolio_id}`);
  }
}
