import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getTrades } from '../../actions/index';
import moment from 'moment';

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
    return trades.map(function(trade, i) {
      return <div key={i}>
        {moment(trade.inserted_at).format('MMM DD h:mm A')} |
        type: {trade.type} | q: {trade.quantity} | asset: {trade.asset_id} | portfolio: {trade.portfolio_id}
      </div>
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
