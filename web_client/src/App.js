import React, { Component } from 'react';
import { connect } from 'react-redux';
import {
  getPortfolios, getCashTotals, getStockTotals, getAssets
} from './actions/index';
import Portfolio from './containers/portfolio'
import './App.css';

export class App extends Component {
  componentWillMount() {
    this.props.getPortfolios();
    this.props.getAssets();
    this.props.getCashTotals();
    this.props.getStockTotals();
  }

  render() {
    return (
      <div className="App">
        {this.mapPortfolios(this.props.portfolios)}
      </div>
    );
  }

  mapPortfolios(portfolios) {
    if (!portfolios) return null
    const that = this;
    return Object.keys(portfolios).map(function(key) {
      const portfolio = portfolios[key]
      return <Portfolio
        key={key}
        portfolio={portfolio}
        cash_holdings={that.props.cash_holdings}
        stock_holdings={that.props.stock_holdings}
        assets={that.props.assets} />
    })
  }
}

const mapStateToProps = (state) => {
  return {
    portfolios: state.portfolios.portfolios,
    assets: state.portfolios.assets,
    stock_holdings: state.portfolios.stock_holdings,
    cash_holdings: state.portfolios.cash_holdings,
  }
}

export default connect(
  mapStateToProps,
  { getPortfolios, getCashTotals, getStockTotals, getAssets }
)(App);
