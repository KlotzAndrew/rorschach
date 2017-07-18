import React, { Component } from 'react';
import { connect } from 'react-redux';

export class Ticks extends Component {
  render() {
    const { ticks } = this.props;
    return (
      <div>{this.mapTicks(ticks)}</div>
    )
  }

  mapTicks(ticks) {
    if (!ticks) { return null }
    return Object.keys(ticks).map(function(tick, i) {
      return <div key={i}>id: {tick}, price: {ticks[tick].ask_price}</div>
    })
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    ticks: state.portfolios.ticks,
  }
}

export default connect(
  mapStateToProps
)(Ticks);
