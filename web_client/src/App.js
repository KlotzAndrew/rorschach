import React, { Component } from 'react';
import { connect } from 'react-redux'
import { getPortfolio } from './actions/index'
import logo from './logo.svg';
import './App.css';

class App extends Component {
  componentWillMount() {
    this.props.getPortfolio();
  }

  render() {
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome to React</h2>
        </div>
        <p className="App-intro">
          <div>{this.props.portfolio.name}</div>
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  portfolio: state.portfolios.portfolio
})

export default connect(
  mapStateToProps,
  { getPortfolio }
)(App)
