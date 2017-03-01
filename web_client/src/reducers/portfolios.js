import * as types from '../constants/actionTypes';

const initialState = {
  portfolio: {}
}

const portfolios = (state = initialState, action) => {
  switch (action.type) {
    case types.SET_PORTFOLIO:
      console.log('action is', action)
      return { portfolio: action.portfolio }
    default:
      return state
  }
}

export default portfolios;
