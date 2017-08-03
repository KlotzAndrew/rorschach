import React from 'react';
// import ReactDOM from 'react-dom';
import { render } from 'react-dom'
import { createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import thunk from 'redux-thunk';
import { Socket } from 'phoenix-socket';
import { addTrade, addTick, updateSignals } from './actions/index'
import App from './App';
import Trades from './containers/pages/trades';
import './index.css';
import reducer from './reducers/index'
import {
  BrowserRouter as Router,
  Route
} from 'react-router-dom';

const store = createStore(
  reducer,
  applyMiddleware(thunk)
)

let socket = new Socket(`${process.env.REACT_APP_WEBSOCKET_SERVER}:4000/socket`);
socket.connect();

let channel = socket.channel('room:lobby', {});

channel.join()
  .receive('ok', resp => { console.log('Joined successfully', resp) })
  .receive('error', resp => { console.log('Unable to join', resp) })

channel.on('new:trade', payload => {
    store.dispatch(addTrade(payload))
  }
);

channel.on('new:tick', payload => {
    store.dispatch(addTick(payload))
  }
);

channel.on('new:signals', payload => {
    store.dispatch(updateSignals(payload))
  }
);

const routes = (
  <div>
    <Route exact={true} path="/" component={App}/>
    <Route exact={true} path="/trades/:id" component={Trades}/>
  </div>
)

render(
  <Provider store={store}>
    <Router>{routes}</Router>
  </Provider>,
  document.getElementById('root')
);
