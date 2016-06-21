import React from 'react';
import debounce from 'debounce';
import PureRenderMixin from 'react-addons-pure-render-mixin';

export default React.createClass({
  displayName: 'favorites-header',
  mixins: [PureRenderMixin],

  propTypes: {
    writeFunc: React.PropTypes.func,
    excelFunc: React.PropTypes.func,
    sendFunc: React.PropTypes.func,
  },

  componentWillMount() {
    this.debouncedChange = debounce(this.onChange, 600);  
  },

  render() {
    return (
      <div className="search-header dailies-header">
        <div className="form-control flex-end flex-vcenter">
          <span onClick={ this.props.writeFunc } className="button button-plain">写日报</span>
          <span onClick={ this.props.excelFunc } className="button button-plain">导出</span>
          <span onClick={ this.props.sendFunc } className="button button-plain">发送</span>
        </div>
      </div>
    );
  }
});
