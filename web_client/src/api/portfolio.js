import axiosInstance from '../config/axios';

export default {
  getPortfolio() {
    return axiosInstance.get('portfolios/1')
  }
}
