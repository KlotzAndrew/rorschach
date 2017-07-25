import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getTradeSignals } from '../../actions/index';
import Currency from '../currency';

export class Portfolio extends Component {
  componentWillMount() {
    this.props.getTradeSignals(this.props.portfolio.id);
  }

  render() {
    const { tradeSignals } = this.props;
    return (
      <div>{this.mapSignals(tradeSignals)}</div>
    )
  }

  mapSignals(tradeSignals) {
    if (!tradeSignals) { return null }
    return Object.keys(tradeSignals).map(function(key, i) {
      const values = tradeSignals[key]
      return <div key={i}>
        Ticker: {key} |
        enter: <Currency value={values.enter} /> |
        exit: <Currency value={values.exit} /> |
        traded: {JSON.stringify(values.traded)}
      </div>
    })
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    tradeSignals: state.portfolios.tradeSignals[ownProps.portfolio.id],
  }
}

export default connect(
  mapStateToProps,
  { getTradeSignals }
)(Portfolio);
