import axios from 'axios';

let axiosInstance = axios.create({
  baseURL: `http://localhost:4000/api/v1`
});

module.exports = axiosInstance;
