import React from 'react';

class SliderButton extends React.Component {
    constructor(props){
      super(props);
  
      this.state = {
        on: false
      }
    }
    render(){
      return(
        <div 
        onClick = {() => {
            this.props.onToggle(!this.state.on);
            this.setState({on: !this.state.on});
        }}
        style={{
          marginLeft: "10px", 
          display: "inline-block", 
          width: "45px", height: "20px", 
          borderRadius: "10px", 
          backgroundColor: this.state.on ? "#2EE88D" : "white",
          textAlign: this.state.on ? "right" : "left"
          }}>
          <div style={{
            display: "inline-block", 
            borderRadius: "50%", 
            height: "20px", 
            width: "20px", 
            backgroundColor: "#555555"
            }}></div>
        </div>
      );
    }
  }

  export default SliderButton;