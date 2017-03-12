import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getPortfolio, getCashTotals, getStockTotals } from './actions/index';
import './App.css';

export class App extends Component {
  componentWillMount() {
    this.props.getPortfolio();
    this.props.getCashTotals();
    this.props.getStockTotals();
  }

  render() {
    return (
      <div className="App">
        <div>{this.props.portfolio.name}</div>
        {this.mapAssets(this.props.assets)}
      </div>
    );
  }

  mapAssets(assets) {
    if (!assets) return null

    return Object.keys(assets).map(function(key) {
      const asset = assets[key]
      return <div key={asset.id}>
        asset_id: {asset.id} | quantity: {asset.quantity}
      </div>
    })
  }
}

const mapStateToProps = (state) => {
  return {
    portfolio: state.portfolios.portfolio,
    assets: state.portfolios.assets,
  }
}

export default connect(
  mapStateToProps,
  { getPortfolio, getCashTotals, getStockTotals }
)(App);
