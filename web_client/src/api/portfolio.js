import axiosInstance from '../config/axios';

export default{
  getPortfolios() {
    return axiosInstance.get('portfolios');
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
