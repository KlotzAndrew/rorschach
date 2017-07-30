import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

export class NavBar extends Component {
  render() {
    return (
      <div>
        <Link to="/">Home</Link>
        <Link to="/trades">Trades</Link>
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {}
}

export default connect(
  mapStateToProps
)(NavBar);
