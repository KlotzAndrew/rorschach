import axiosInstance from '../config/axios';

export default{
  getPortfolio() {
    return axiosInstance.get('portfolios/1');
  },

  getAssets() {
    return axiosInstance.get('assets');
  },

  getCashTotals() {
    return axiosInstance.get('trades/cash_sums/1');
  },

  getStockTotals() {
    return axiosInstance.get('trades/stock_sums/1');
  }
}
