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

        <table>
          <tr>
            <th>Name</th>
            <th>Quantity</th>
            <th>Price</th>
          </tr>

          <tr>
            <td>Total</td>
            <td>-</td>
            <td>{this.totalValue().toFixed(2)}</td>
          </tr>

          {this.mapAssets(this.props.cash_holdings)}
          {this.mapAssets(this.props.stock_holdings)}
        </table>
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
      return <tr key={holding.id}>
        <td>{asset.name}</td>
        <td>{holding.quantity.toFixed(0)}</td>
        <td>{(holding.quantity * (holding.price || 1)).toFixed(2)}</td>
      </tr>
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
