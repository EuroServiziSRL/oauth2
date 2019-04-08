import React, { Component } from 'react';
import LoadingOverlay from 'react-loading-overlay';
import PulseLoader from 'react-spinners/PulseLoader';

class MyLoader extends Component {
    
    constructor(props){
        console.log(props)
        super(props);
       
        this.state = {
          active: props.active,
          children: props.children
        };
    
    }


    componentWillReceiveProps(nextProps){
        if(nextProps.active !== this.state.active){
          console.log("setto active", nextProps.active);
        }
      }


    render() { 
        return (
            <LoadingOverlay active={this.state.active} spinner={<PulseLoader />} classNamePrefix='MyLoader_' >
              {this.state.children}
            </LoadingOverlay>
        )
    }
}

export default MyLoader;
