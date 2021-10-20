import React from 'react';
import axios from 'axios';
import logo from './images/logo-dark.png';
import LabeledField from './components/LabeledField.js';
import SliderButton from './components/SliderButton.js';
import './css/Profile.css';
import { FormControl, Modal, Row } from 'react-bootstrap';

const TempSlider = (props) => {
  return (
    <div>
      {props.slider ?
        <SliderButton onToggle={(toValue) => { if (props.onSliderToggle != null) props.onSliderToggle(toValue); }} />
        : ""
      }
    </div>
  );
};

//let LOCAL_STORAGE_USERNAME_KEY = "username"
let LOCAL_STORAGE_TOKEN_KEY = "auth_token" 

let restTemplate;

class ProfileModal extends React.Component {
  render() {
    return (
      <Modal
        id="black-bear-modal"
        dialogClassName="profile-modal-content"
        show={this.props.showing}
        onHide={this.props.hideModal}
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title>Weekly Summary Email</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="modal-category">
            <Row style={{ marginLeft: 0 }}>
              Devices not connected for
              <FormControl style={{ margin: "0 1em 0 1em", height: "1.5em", width: "3em" }} type="text" placeholder="90" /> days:
              <TempSlider slider={true} style={{ float: "right" }} />
            </Row>
          </div>
          <LabeledField text={false} label="Devices not responding" slider={true} />
          <LabeledField label="Abnormal connection activity" slider={true} />
        </Modal.Body>
      </Modal>
    );
  }
}

class Profile extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      weeklySummary: false,
      monthlySummary: false,
      SMSAlerts: false,
      modalShowing: false,
      profileInfo: {}
    }

    this.showModal = this.showModal.bind(this);
    this.hideModal = this.hideModal.bind(this);
    this.generateNameString = this.generateNameString.bind(this);
    this.requestProfileInfo = this.requestProfileInfo.bind(this);
  }

  componentDidMount() {
    const authHeader = localStorage.getItem(LOCAL_STORAGE_TOKEN_KEY);
    restTemplate = axios.create({
      baseURL: process.env["REACT_APP_BACKEND_URL"],
      timeout: 100000,
      headers: { Authorization: authHeader}
    });

    this.requestProfileInfo();
  }

  requestProfileInfo() {
    restTemplate.get('/user/user-profile')
    .then(response => {
      this.setState({profileInfo: response.data});
    })
    .catch(e => {
      console.log(e);
    });
  }


  showModal = () => {
    this.setState({ modalShowing: true });
    console.log("card click");
  }

  hideModal = () => {
    this.setState({ modalShowing: false });
    console.log("clicked hide");
  }

  generateNameString = () => {
    if (this.state.profileInfo.FirstName !== null || this.state.profileInfo.LastName !== null) {
      return this.state.profileInfo.FirstName + ' ' + this.state.profileInfo.LastName;
    }
    else return "No Name Saved for Profile";
  }

  render() {
    return (
      <>
        <ProfileModal showing={this.state.modalShowing} showModal={this.showModal} hideModal={this.hideModal} />
        <div id="watermark-container">
          <img src={logo} id="background-logo" alt="Black Bear watermark logo" />
        </div>
        <div id="profile-page-header">
          <div className="material-icons" id="profile-picture">
            account_circle
                </div>
          <div>
            <h1>{this.generateNameString()}</h1>
            <button className="green-link-button">Edit Profile</button>
            <button
            onClick={() => {
              this.props.onLogout();
            }}
            className="red-link-button"
            >Log out</button>
          </div>
        </div>
        <div className="section-header container">Personal Information</div>
        <div className="container">
        <LabeledField label="Username" text={this.state.profileInfo.UserName} />
          <LabeledField label="Role" text={this.state.profileInfo.UserRole} />
          <LabeledField label="Email" text={this.state.profileInfo.Email} />
          <LabeledField label="Phone" text={this.state.profileInfo.Phone} />
        </div>
        <div className="section-header container">Notifications</div>
        <div className="container">
          <Row style={{ marginLeft: 0 }}>
            <LabeledField label="Weekly Summary Email" slider={this.state.profileInfo.WeeklySummary == null} />
            <button style={{ padding: "0 0 1em 1em" }} className="green-link-button" onClick={() => this.showModal()}>Configure</button>
          </Row>
          <Row style={{ marginLeft: 0 }}>
            <LabeledField label="Monthly Summary Email" slider={this.state.profileInfo.MonthlySummary == null} />
            <button style={{ padding: "0 0 1em 1em" }} className="green-link-button" onClick={() => this.showModal()}>Configure</button>
          </Row>
          <LabeledField label="SMS Alerts on Outages" slider={true} />
        </div>
      </>
    );
  }
}

export default Profile;