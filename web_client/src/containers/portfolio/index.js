import React, { Component } from 'react';
import { connect } from 'react-redux';

export class Portfolio extends Component {
  componentWillMount() {
  }

  render() {
    return (
      <table>
        <caption>{this.props.portfolio.name}</caption>
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

  }
}

export default connect(
  mapStateToProps,
  {}
)(Portfolio);
