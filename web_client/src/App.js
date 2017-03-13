import React, { Component } from 'react';
import { connect } from 'react-redux';
import {
  getPortfolio, getCashTotals, getStockTotals, getAssets
} from './actions/index';
import './App.css';

export class App extends Component {
  componentWillMount() {
    this.props.getPortfolio();
    this.props.getAssets();
    this.props.getCashTotals();
    this.props.getStockTotals();
  }

  render() {
    return (
      <div className="App">
        <div>{this.props.portfolio.name}</div>

        <div>Stocks</div>
        {this.mapAssets(this.props.stock_holdings)}

        <div>Cash</div>
        {this.mapAssets(this.props.cash_holdings)}

        <div>Total</div>
        {this.totalValue()}
      </div>
    );
  }

  mapAssets(holdings) {
    if (!holdings) return null
    const assets = this.props.assets

    return Object.keys(holdings).map(function(key) {
      const holding = holdings[key]
      const asset = assets[holding.id]

      if (!asset) return null
      return <div key={holding.id}>
        {asset.name}
        | q: {holding.quantity}
        | v: {holding.quantity * (holding.price || 1)}
      </div>
    })
  }

  totalValue() {
    const stock_total = this.assetTotal(this.props.stock_holdings)
    const cash_total = this.assetTotal(this.props.cash_holdings)

    return stock_total + cash_total
  }

  assetTotal(holdings) {
    const keys = Object.keys(holdings)
    if (keys.length === 0) return null

    return keys.reduce(function(acc, key) {
      const holding = holdings[key]
      return acc + (holding.quantity * (holding.price || 1))
    }, 0)
  }
}

const mapStateToProps = (state) => {
  return {
    portfolio: state.portfolios.portfolio,
    assets: state.portfolios.assets,
    stock_holdings: state.portfolios.stock_holdings,
    cash_holdings: state.portfolios.cash_holdings,
  }
}

export default connect(
  mapStateToProps,
  { getPortfolio, getCashTotals, getStockTotals, getAssets }
)(App);
