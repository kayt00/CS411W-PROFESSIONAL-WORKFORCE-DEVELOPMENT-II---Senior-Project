import React from 'react';
import './css/Advanced.css';
import logo from './images/logo-dark.png';
import LabeledField from './components/LabeledField'

class Advanced extends React.Component {
  render() {
    return (
      <div>
        <div id='watermark-container'>
          <img src={logo} id='background-logo' alt='Black Bear watermark logo' />
        </div>
        <div className="section-header container">Security</div>
          <div className="container" style={{marginBottom: "40px"}}>
            <LabeledField label="Block Network Traffic from:" text="Russia, North Korea, Iran" button="Edit"/>
          </div>
        <div className="section-header container">SSH Server</div>
        <div className="container" style={{marginBottom: "40px"}}>
            <LabeledField label="Username" text="admin" button="Edit"/>
            <LabeledField label="Internal IP Address" text="192.168.223.1" button="Edit"/>
            <button className='green-link-button'>Change Password</button>
        </div>
        <div className="section-header container">Honeypot</div>
        <div className="container" style={{marginBottom: "40px"}}>
          <LabeledField label="Internal IP Address" text="192.168.34.2" button="Edit"/>
          <LabeledField label="Open Ports" text="20, 23, 80" button="Edit"/>
          <LabeledField label="Push notifications when attacked" slider={true}/>
          <LabeledField label="Remove attacker from network" slider={true}/>
          <LabeledField label="Permanently block attacker's MAC address" slider={true}/>
        </div>
      </div>
    );
  }
}

export default Advanced;