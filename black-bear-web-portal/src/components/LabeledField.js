import React from 'react'
import SliderButton from './SliderButton.js'
const LabeledField = (props) => {
    return(
              <div className="category" style={{ marginBottom: "20px" }}>
                {props.label}:

                {props.text != null ?
                <div className="details">{props.text}</div>
                : ""
                }

                {props.slider ? 
                    <SliderButton onToggle={(toValue) => {if (props.onSliderToggle != null) props.onSliderToggle(toValue);}}/>
                    : ""
                }
                
                {props.button != null ? 
                <button className="green-link-button" onClick = {() => { if (props.onButtonClick != null) props.onButtonClick();}}>{props.button}</button>
                : ""
                }
              </div>
    );
};

export default LabeledField;