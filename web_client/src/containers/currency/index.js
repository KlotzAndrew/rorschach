import React from 'react';

export default ({ value }) => {
  return <span>${parseFloat(value, 10).toFixed(2)}</span>
}
