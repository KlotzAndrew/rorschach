import axiosInstance from '../config/axios';

export default{
  getPortfolio() {
      return axiosInstance.get('portfolios/1')
  },

  getAssetTotals() {
      return axiosInstance.get('trades/asset_sums/1')
  }
}
