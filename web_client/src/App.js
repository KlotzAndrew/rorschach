import React, { Component } from 'react';
import { connect } from 'react-redux';
import {
  getPortfolios, getAssets
} from './actions/index';
import Portfolio from './containers/portfolio'
import Trades from './containers/trades';
import Ticks from './containers/ticks';
import TradeSignals from './containers/tradeSignals'
import NavBar from './containers/navBar'
import { Link } from 'react-router-dom';
import './App.css';

export class App extends Component {
  componentWillMount() {
    this.props.getPortfolios();
    this.props.getAssets();
  }

  render() {
    return (
      <div className="App">
        <div>Rorschack</div>
        <NavBar />

        <div>Portfolios</div>
        {this.mapPortfolios(this.props.portfolios)}

        <div>Trades</div>
        <Trades />

        <div>Ticks</div>
        <Ticks />
      </div>
    );
  }

  mapPortfolios(portfolios) {
    if (!portfolios) return null;
    const that = this;
    return Object.keys(portfolios).map(function(key) {
      const portfolio = portfolios[key];
      return <div>
        <Portfolio
          key={key}
          portfolio={portfolio}
          assets={that.props.assets} />
        <Link to={`/trades/${portfolio.id}`}>Trades</Link>
        <TradeSignals
          key={key + 'ts'}
          portfolio={portfolio} />
      </div>
    })
  }
}

const mapStateToProps = (state) => {
  return {
    portfolios: state.portfolios.portfolios,
    assets: state.portfolios.assets
  }
}

export default connect(
  mapStateToProps,
  { getPortfolios, getAssets }
)(App);
