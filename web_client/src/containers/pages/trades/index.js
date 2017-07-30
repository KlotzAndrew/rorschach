import React, { Component } from 'react';
import { connect } from 'react-redux';
import NavBar from '../../navBar';

export class Trades extends Component {
  render() {
    return (
      <div>
        <h2>Trades</h2>
        <NavBar />
        TBD
      </div>
  )}
}

const mapStateToProps = (state, ownProps) => {
  return {
    portfolio: state.portfolios.portfolios[ownProps.match.params.id]
  }
}

export default connect(
  mapStateToProps,
  {}
)(Trades);
