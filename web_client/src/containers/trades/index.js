import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getTrades } from '../../actions/index';

export class Portfolio extends Component {
  componentWillMount() {
    this.props.getTrades();
  }

  render() {
    const { trades } = this.props;
    return (
      <div>{this.mapTrades(trades)}</div>
    )
  }

  mapTrades(trades) {
    if (!trades) { return null }
    return trades.map(function(trade) {
      return <div>{JSON.stringify(trade)}</div>
    })
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    trades: state.portfolios.trades,
  }
}

export default connect(
  mapStateToProps,
  { getTrades }
)(Portfolio);
