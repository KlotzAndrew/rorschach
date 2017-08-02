import axios from 'axios';

let axiosInstance = axios.create({
  baseURL: `${process.env.REACT_APP_API_URL}:4000/api/v1`
});

module.exports = axiosInstance;
