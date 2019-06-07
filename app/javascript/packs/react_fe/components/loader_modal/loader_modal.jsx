import React, { Component } from 'react';
import LoadingOverlay from 'react-loading-overlay';
import PulseLoader from 'react-spinners/PulseLoader';


class MyLoader extends Component {
    
    constructor(props){
        console.log("Costruttore loader: ",props)
        super(props);
       
        this.state = {
          active: props.active,
          children: props.children
        };
    }

    static getDerivedStateFromProps(nextProps, prevState){
        console.log("arrivano props", nextProps);
        if(nextProps.active !== prevState.active){
          return { active: nextProps.active};
        }
        else return null;
    }
    
    componentDidUpdate(prevProps, prevState) {
        console.log("component update", prevProps);
        if(prevProps.active !== this.props.active){
            //Perform some operation here
            //this.setState({active: true});
            //this.classMethod();
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
