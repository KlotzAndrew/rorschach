import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getTradeSignals, toggleAssetTrack } from '../../actions/index';
import Currency from '../currency';
import styles from './style.scss';

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
        {this.mapSignals(tradeSignals, this.props.portfolio.id, this)}
        <div>
          <input
            type="text"
            value={this.state.ticker}
            placeholder="Add ticker"
            onChange={e => this.setState({ticker: e.target.value})}
            onKeyPress={this.addAssetTrack}/>
        </div>
      </div>
    )
  }

  mapSignals(tradeSignals, portfolioId, that) {
    if (!tradeSignals) { return null }
    return Object.keys(tradeSignals).map(function(ticker, i) {
      const values = tradeSignals[ticker]
      return <div
        key={i}
        className={styles.remove}
        onClick={() => that.removeAssetTrack(portfolioId, ticker)} >
          Ticker: {ticker} |
          enter: <Currency value={values.enter} /> |
          exit: <Currency value={values.exit} /> |
          traded: {JSON.stringify(values.traded)}
      </div>
    })
  }

  removeAssetTrack = (portfolioId, ticker) => {
    this.props.toggleAssetTrack(portfolioId, ticker, false)
  }

  addAssetTrack = event => {
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
