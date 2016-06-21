import cx from 'classnames';
import React from 'react';
import recorder from 'actions-recorder';
import Immutable from 'immutable';

import query from '../query';
import eventBus from '../event-bus';
import 'react-datepicker/dist/react-datepicker.css';
import routerHandlers from '../handlers/router';

import DailyAction from '../actions/daily';


import lang from '../locales/lang';

import mixinFinder from '../mixin/finder-mixin';
import mixinSubscribe from '../mixin/subscribe';

import DailiesHeader from './dailies-header';

import LightModal from '../module/light-modal';
import DatePicker from 'react-datepicker';
import moment from 'moment';
import LinkedStateMixin from 'react-addons-linked-state-mixin';
import ButtonSingleAction from  '../module/button-single-action';

import NotifyActions from '../actions/notify';
import LightCheckbox from '../module/light-checkbox';

export default React.createClass({
  displayName: 'dailies-page',
  mixins: [mixinSubscribe, mixinFinder, LinkedStateMixin],
  propTypes: {
    _teamId: React.PropTypes.string.isRequired,
    router: React.PropTypes.instanceOf(Immutable.Map).isRequired,
  },

  getInitialState() {
    return {
      showDailyModal: false,
      test: moment(),
      production: moment(),
      project: '',
      work: '',
      pmList: ['冯新', '毕务龙', '盛同章', '王永吉'],
      progress: 0.1,
      pm: '冯新',
      results: Immutable.List(),
    };
  },

  componentDidMount() {
    this.subscribe(recorder, () => {
      const results = this.getResults().map((daily) => daily.set('selected', true));
      const daily = results.find((value) => value.get('_creatorId') === query.userId(recorder.getState()));
      const state = { results };
      if (daily) {
        state.work = daily.get('work');
        state.project = daily.get('project');
        state.pm = daily.get('pm');
        state.progress = daily.get('progress');
        state.test = moment(daily.get('testDate'));
        state.production = moment(daily.get('productionDate'));
      }
      this.setState(state);
    });    
  },

  getResults: function() {
    console.log('get results');
    return query.dailiesBy(recorder.getState(), this.props._teamId);
  },

  testDate: function(date) {
    console.log(date);
    this.setState({ test: date });
  },

  productionDate: function(date) {
    console.log(date);
    this.setState({ production: date });
  },

  getRoomId: () => this.props.router.getIn(['query', '_roomId']),

  getToId: () => this.props.router.getIn(['query', '_toId']),

  onClose: () => routerHandlers.changeChannel(this.props._teamId, this.getRoomId(), this.getToId()),

  save: function(complete) {
    const { project, work, pm, progress, test, production } = this.state;
    const { _teamId } = this.props;
    console.log(project, work);
    if (project.length === 0) {
      NotifyActions.error('请填写项目名称');
      complete();
    } else if (work.length === 0) {
      NotifyActions.error('请填写工作内容')
      complete();
    } else {
      DailyAction.createDaily({
        project,
        work,
        pm,
        progress,
        testDate: test.toDate(),
        productionDate: production.toDate(),
        _teamId,
      }, (data) => {
        console.log('data:', data);
        complete();
        this.setState({ showDailyModal: false });
        
      }, (error) => {
        console.error(error);
        complete();
      });
    }
  },

  selectPm: function(e) {
    const { pmList } = this.state;
    this.setState({
      pm: pmList[e.target.value],
    });
  },

  selectProgress: function(e) {
    this.setState({
      progress: e.target.value,
    });
  },

  selectDaily: function(index) {
    const { results } = this.state;
    console.log(index);
    this.setState({
      results: results.update(index, (daily) => daily.set('selected', !daily.get('selected'))),
    });
  },

  excelFunc: function() {
    const { results } = this.state;
    const _ids = results.filter((daily) => daily.get('selected')).reduce((ids, daily) => ids + (ids.length > 0 ? ',' : '') + daily.get('_id'), '');
    console.log(_ids);
    if (_ids.length === 0) {
      return NotifyActions.error('请先勾选要发送的日报');
    }
    DailyAction.createExcel({
      _ids,
    }, (data) => {
      console.log('data', data);
    }, (error) => {
      console.error(error);
    });
  },

  sendFunc: function() {
    const { results } = this.state;
    const { _teamId } = this.props;
    const _ids = results.filter((daily) => daily.get('selected')).reduce((ids, daily) => ids + (ids.length > 0 ? ',' : '') + daily.get('_id'), '');
    if (_ids.length === 0) {
      return NotifyActions.error('请先勾选要发送的日报');
    }
    DailyAction.sendDaily({
      _ids,
      _teamId,
    }, (data) => {
      console.log('data:', data);
    }, (error) => {
      console.error(error);
      NotifyActions.error('只有管理员可以发送日报哦');
    });
  },

  render() {
    const { pmList, results } = this.state;
    console.log('query', this.props.router.toJS());
    const pmOptions = pmList.map((pm, index) => {
      return <option key={ index } value={ index }>{ pm }</option>;
    });

    const progressOptions = [];
    for (let i = 1; i <= 10; i++) {
      progressOptions.push(<option key={ i } value={ i / 10 }>{ `${i * 10}%` }</option>);
    }

    const dailyCells = results.map((daily, index) => {
      return (<div className="daily-row" key={index}>
        <div className="daily-cell">{ daily.getIn(['creator', 'name']) }</div>
        <div className="daily-cell">{ daily.get('project') }</div>
        <div className="daily-cell daily-work">{ daily.get('work') }</div>
        <div className="daily-cell">{ `${daily.get('progress') * 100}%` }</div>
        <div className="daily-cell">{ moment(daily.get('testDate')).format('YYYY/MM/DD') }</div>
        <div className="daily-cell">{ moment(daily.get('productionDate')).format('YYYY/MM/DD') }</div>
        <div className="daily-cell">{ daily.get('pm') }</div>
        <div className="daily-cell">
          <LightCheckbox name="选择日报" checked={ daily.get('selected') } onClick={ this.selectDaily.bind(this, index) } />
        </div>
      </div>);
    });
    return (
      <div className="finder-page favorites-page flex-space">
        <div className="header">
          <DailiesHeader 
            _teamId={this.props._teamId} 
            writeFunc={() => this.setState({ showDailyModal: true })}
            excelFunc={ this.excelFunc }
            sendFunc={ this.sendFunc } />
        </div>
        <div className="daily-list">
          <div className="daily-header">
            <div className="daily-cell">姓名</div>
            <div className="daily-cell">项目</div>
            <div className="daily-cell daily-work">工作内容</div>
            <div className="daily-cell">进度</div>
            <div className="daily-cell">提测时间</div>
            <div className="daily-cell">上线时间</div>
            <div className="daily-cell">产品汪</div>
          </div>
          { dailyCells }
        </div>
        <LightModal onCloseClick={() => this.setState({ showDailyModal: false })} show={this.state.showDailyModal} >
          <div className="daily-modal">
            <h2 className="daily-title">日报</h2>
            <div className="form-table">
              <div className="form-row flex-horiz">
                <sapn className="input-title">项目:</sapn>
                <input valueLink={ this.linkState('project') } type="text" className="text-row font-normal text-overflow" placeholder="项目名称" />
              </div>
              <div className="form-row flex-horiz">
                <sapn className="input-title">工作:</sapn>
                <textarea valueLink={ this.linkState('work') } rows="4" className=" font-normal" placeholder="工作内容" />
              </div>
              <div className="form-row flex-horiz">
                <sapn className="input-title">产品:</sapn>
                <select onChange={ this.selectPm }>
                  { pmOptions }
                </select>
              </div>
              <div className="form-row flex-horiz">
                <sapn className="input-title">进度:</sapn>
                <select onChange={ this.selectProgress }>
                  { progressOptions }
                </select>
              </div>
              <div className="form-row flex-horiz">
                <sapn style={{ paddingTop: '8px' }} className="input-title">提测:</sapn>
                <div className="input-date">
                  <DatePicker
                    selected={ this.state.test }
                    startDate={ moment() }
                    endDate={ moment().add(60, 'days') }
                    readOnly={ true }
                    todayButton="今天"
                    onChange={ this.testDate } 
                    placeholderText="请选择提测时间" />
                </div>
              </div>
              <div className="form-row flex-horiz">
                <sapn style={{ paddingTop: '8px' }} className="input-title">上线:</sapn>
                <div className="input-date">
                  <DatePicker
                    selected={ this.state.production }
                    startDate={ moment() }
                    endDate={ moment().add(60, 'days') }
                    todayButton="今天"
                    readOnly={ true }
                    onChange={ this.testDate } 
                    placeholderText="请选择上线时间" />
                </div>
              </div>
            </div>
          </div>
          <div className="flex-horiz flex-end">
            <div className="button button-plain" onClick={ () => this.setState({ showDailyModal: false }) }>取消</div>
            <ButtonSingleAction className="button button-plain" onClick={ this.save }>提交</ButtonSingleAction>
          </div>
        </LightModal>
      </div>
    );
  }
});
