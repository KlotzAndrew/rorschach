import React, { Component } from 'react';
import { connect } from 'react-redux';
import { getTrades } from '../../actions/index';
import Currency from '../currency';
import AssetName from '../assetName';
import moment from 'moment';

import styles from './style.scss';

export class Portfolio extends Component {
  componentWillMount() {
    this.props.getTrades();
  }

  render() {
    const { trades } = this.props;
    return (
      <div className={styles.container}>
        {this.headers()}
        {this.mapTrades(trades)}
      </div>
    )
  }

  headers = () => (
    <div className={styles.row}>
      <div className={styles.item}>Time</div>
      <div className={styles.item}>Type</div>
      <div className={styles.item}>Quantity</div>
      <div className={styles.name}>Asset</div>
      <div className={styles.item}>Portfolio</div>
      <div className={styles.item}>Price</div>
    </div>
  )

  mapTrades(trades) {
    if (!trades) { return null }
    return trades.map(function(trade, i) {
      return <div className={styles.row} key={i}>
        <span className={styles.item}>{moment(trade.inserted_at).format('MMM DD h:mm A')}</span>
        <span className={styles.item}>{trade.type}</span>
        <span className={styles.item}>{trade.quantity}</span>
        <span className={styles.name}><AssetName assetId={trade.asset_id} /></span>
        <span className={styles.item}>{trade.portfolio_id}</span>
        <span className={styles.price}><Currency value={trade.price} /></span>
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
