import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getCashHoldings, getStockHoldings } from '../../actions/index';

export class Portfolio extends Component {
  componentWillMount() {
    this.props.getCashHoldings(this.props.portfolio.id);
    this.props.getStockHoldings(this.props.portfolio.id);
  }

  render() {
    const { portfolio, cash_holdings, stock_holdings } = this.props;
    return (
      <table>
        <caption>{portfolio.name}</caption>
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

        {this.mapAssets(cash_holdings)}
        {this.mapAssets(stock_holdings)}
      </table>
    );
  }

  mapAssets(holdings) {
    if (!holdings) return null
    const assets = this.props.assets

    return Object.keys(holdings).map(function(key, i) {
      const holding = holdings[key]
      const asset = assets[holding.id]

      if (!asset) return null
      return <tr key={i}>
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
    if (!holdings) return 0
    const keys = Object.keys(holdings)
    if (keys.length === 0) return 0

    return keys.reduce(function(acc, key) {
      const holding = holdings[key]
      return acc + (holding.quantity * (holding.price || 1))
    }, 0)
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    stock_holdings: state.portfolios.stock_holdings[ownProps.portfolio.id],
    cash_holdings: state.portfolios.cash_holdings[ownProps.portfolio.id]
  }
}

export default connect(
  mapStateToProps,
  { getCashHoldings, getStockHoldings }
)(Portfolio);
