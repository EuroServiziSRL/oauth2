import React, { Component } from 'react';
import LoadingOverlay from 'react-loading-overlay';
import PulseLoader from 'react-spinners/PulseLoader';

class MyLoader extends Component {
    
    constructor(props){
        super(props);
       
        this.state = {
          active: props.active,
          children: props.children
        };
    
    }


    componentWillReceiveProps(nextProps){
        if(nextProps.active!==this.props.active){
          console.log("setto active", nextProps.active);
        }
      }


    render() { 
        return (
            <LoadingOverlay active={props.active} spinner={<PulseLoader />} classNamePrefix='MyLoader_' >
              {props.children}
            </LoadingOverlay>
        )
    }
}

export default MyLoader;
