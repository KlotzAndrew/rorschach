import React, { Component } from 'react';
import { connect } from 'react-redux';

export class AssetName extends Component {
  render() {
    return (
      <span>{this.props.asset.name}</span>
    )
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    asset: state.portfolios.assets[ownProps.assetId]
  }
}

export default connect(
  mapStateToProps,
  {}
)(AssetName);
