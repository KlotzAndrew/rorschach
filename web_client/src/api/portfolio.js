import axiosInstance from '../config/axios';

export default{
  getPortfolio() {
    return axiosInstance.get('portfolios/1')
  },

  getCashTotals() {
    return axiosInstance.get('trades/cash_sums/1')
  },

  getStockTotals() {
    return axiosInstance.get('trades/stock_sums/1')
  }
}
