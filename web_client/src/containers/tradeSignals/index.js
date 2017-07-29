import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getTradeSignals, toggleAssetTrack } from '../../actions/index';
import Currency from '../currency';

export class Portfolio extends Component {
  componentWillMount() {
    this.props.getTradeSignals(this.props.portfolio.id);
  }

  state = {
    ticker: '',
  };

  render() {
    const { tradeSignals } = this.props;
    return (
      <div>
        <div>trade signals</div>
        {this.mapSignals(tradeSignals)}
        <div>
          <input
            type="text"
            value={this.state.ticker}
            placeholder="Add ticker"
            onChange={e => this.setState({ticker: e.target.value})}
            onKeyPress={this.submitTicker}/>
        </div>
      </div>
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

  submitTicker = event => {
    if (event.key === 'Enter') {
      this.props.toggleAssetTrack(this.props.portfolio.id, this.state.ticker, true)
      this.setState({ticker: ''});
    }
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    tradeSignals: state.portfolios.tradeSignals[ownProps.portfolio.id],
  }
}

export default connect(
  mapStateToProps,
  { getTradeSignals, toggleAssetTrack }
)(Portfolio);
