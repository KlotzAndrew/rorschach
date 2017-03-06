import React from 'react';
// import ReactDOM from 'react-dom';
import { render } from 'react-dom'
import { createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import thunk from 'redux-thunk';
import { Socket } from 'phoenix-socket';
import { addTrade } from './actions/index'
import App from './App';
import './index.css';
import reducer from './reducers/index'

const store = createStore(
  reducer,
  applyMiddleware(thunk)
)

let socket = new Socket(`ws:localhost:4000/socket`);
socket.connect();

let channel = socket.channel('room:lobby', {});

channel.join()
  .receive('ok', resp => { console.log('Joined successfully', resp) })
  .receive('error', resp => { console.log('Unable to join', resp) })

channel.on('new:trade', payload => {
    store.dispatch(addTrade(payload))
  }
);

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);
