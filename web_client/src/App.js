import React, { Component } from 'react';
import { connect } from 'react-redux';
import {
  getPortfolios, getAssets
} from './actions/index';
import Portfolio from './containers/portfolio'
import './App.css';

export class App extends Component {
  componentWillMount() {
    this.props.getPortfolios();
    this.props.getAssets();
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
        assets={that.props.assets} />
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
