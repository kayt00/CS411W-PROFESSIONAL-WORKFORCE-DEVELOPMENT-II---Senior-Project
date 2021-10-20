import React from 'react';
import './css/Devices.css'
import { Card, Col, Container, Dropdown, Form, FormControl, Modal, Row } from 'react-bootstrap';
//import arrow from './images/arrow.png';
import logo from './images/logo-dark.png';
import LabeledField from './components/LabeledField';
import axios from 'axios';

let LOCAL_STORAGE_TOKEN_KEY = "auth_token"
let restTemplate;

class DeviceModal extends React.Component {
  constructor(props) {
    super(props);
    this.moveDeviceToVlan = this.moveDeviceToVlan.bind(this);
  }
  moveDeviceToVlan(vlanID) {
    if (restTemplate != null) {
      restTemplate.post('/device/move', {
        id: this.props.device.DeviceRecordIdentifier,
        toVlan: vlanID
      }).then(response => {
        console.log("Successfully moved device.");
        this.props.moveDeviceReload();
        this.props.hideModal();
      }).catch(e => {
        console.log(e);
      });
    }
  }
  deleteDevice(deviceID) {
    if (restTemplate != null) {
      restTemplate.delete('/device/' + deviceID, {
        id: deviceID
      }).then(response => {
        console.log("Successfully deleted device.");
        this.props.moveDeviceReload();
        this.props.hideModal();
      }).catch(e => {
        console.log(e);
      });
    }
  }
  render() {
    return (
      this.props.showing ?
        <Modal
          id="black-bear-modal"
          show={this.props.showing}
          onHide={this.props.hideModal}
          centered
        >
          <Modal.Header closeButton>
            <Modal.Title>{this.props.device.DeviceName}</Modal.Title>
          </Modal.Header>
          <Modal.Body>

            {/* TODO: Incorporate backend data */}

            <div className="modal-category">
              MAC:
            <div className="details">{this.props.device.MacAddress}</div>
            </div>
            <div className="modal-category">
              IP Address
            <div className="details">{this.props.device.IPAddress}</div>
            </div>
            <div className="modal-category">
              Connected Since:
            <div className="details">{this.props.device.CreationDate}</div>
            </div>
            <div className="modal-category">
              Registered On:
            <div className="details">{this.props.device.ConnectedSince}</div>
            </div>
            <div className="modal-category">
              Registered By:
            {/* Info not accessible by backend */}
              <div className="details">Harry Trenton</div>
            </div>
            <div className="modal-category">
              Average Daily Upload Traffic:
            <div className="details">1.2 KB</div>
              <button className="modal-button">{this.props.device.UploadLimitMB == null ? "Add Limit" : "Limit: " + this.props.device.UploadLimitMB + "MB"}</button>
            </div>
            <div className="modal-category">
              Average Daily Download Traffic:
            <div className="details">3.6 MB</div>
              <button className="modal-button">{this.props.device.DownloadLimitMB == null ? "Add Limit" : "Limit: " + this.props.device.DownloadLimitMB + "MB"}</button>
            </div>
            <LabeledField id="modal-category" label="SMS Alert When Device Disconnects" slider={true}>
            </LabeledField>
          </Modal.Body>
          <Modal.Footer>
            <button onClick={() => this.deleteDevice(this.props.device.DeviceRecordIdentifier)} id="remove-button">Remove This Device</button>
            <Dropdown>
              <Dropdown.Toggle id="move-dropdown">
                Change VLAN
              </Dropdown.Toggle>

              <Dropdown.Menu>
                {this.props.vlans.map(vlan => {
                  return (
                    this.props.device.Vlan !== vlan.VlanRecordIdentifier ? (
                      <Dropdown.Item onClick={() => this.moveDeviceToVlan(vlan.VlanRecordIdentifier)}>{vlan.VlanName}</Dropdown.Item>
                    ) : ("")
                  );
                })}
              </Dropdown.Menu>
            </Dropdown>
          </Modal.Footer>
        </Modal>
        : ""
    );
  }
}

class Devices extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      // 0 -> nothing showing
      // 1 -> device modal open 
      // 2 -> page not active
      currentFlowStatus: 0,
      checkLoop: null,
      deviceMoved: false,
      activeDevice: null,
      modalShowing: false,
      vlans: [],
      devices: []
    }
    this.moveDeviceReload = this.moveDeviceReload.bind(this);
    this.showModal = this.showModal.bind(this);
    this.hideModal = this.hideModal.bind(this);
    this.requestVlans = this.requestVlans.bind(this);
    this.requestDevices = this.requestDevices.bind(this);
  }
  moveDeviceReload = () => {
    this.requestDevices();
  }
  showModal = (deviceId) => {
    this.setState({
      currentFlowStatus: 1,
      modalShowing: true,
      activeDevice: deviceId
    });
  }
  hideModal = () => {
    this.setState({
      currentFlowStatus: 0,
      modalShowing: false,
      activeDevice: null
    });
  }
  componentDidMount() {
    const authHeader = localStorage.getItem(LOCAL_STORAGE_TOKEN_KEY);
    restTemplate = axios.create({
      baseURL: process.env["REACT_APP_BACKEND_URL"],
      timeout: 100000,
      headers: { Authorization: authHeader }
    });
    this.requestVlans();
    this.requestDevices();

    var loop = setInterval(this.requestDevices, 5000);
    this.setState({ checkLoop: loop });
    // this.requestUsers();
    // this.requestHostname();
  }
  componentWillUnmount() {
    clearInterval(this.state.checkLoop);
  }
  requestVlans = () => {
    restTemplate.get('/vlan/all').then(response => {
      this.setState({ vlans: response.data });
    }).catch(e => {
      console.log(e);
    });
  }
  requestDevices = () => {
    restTemplate.get('/device/all').then(response => {
      this.setState({ devices: response.data });
    }).catch(e => {
      console.log(e);
    });
  }
  render() {
    return (
      <div>
        <DeviceModal showing={this.state.modalShowing}
          showModal={this.showModal}
          hideModal={this.hideModal}
          vlans={this.state.vlans}
          moveDeviceReload={this.moveDeviceReload}
          device={this.state.modalShowing ? this.state.devices.find(it => it.DeviceRecordIdentifier === this.state.activeDevice) : null}
        />
        <div id='watermark-container'>
          <img src={logo} id='background-logo' alt='Black Bear watermark logo' />
        </div>
        <Container className="device-search">
          <Form inline>
            <FormControl type="text" placeholder="Search Devices" />
          </Form>
        </Container>
        <Row style={{ "margin": "2% 1% 0 1%" }}>
          {this.state.vlans.map(vlan => {
            var offlineDevices = false;
            return <Col key={vlan.VlanRecordIdentifier}>
              <Container className="section-header">{vlan.VlanName}</Container>
              <Container className="device-list">
                {this.state.devices.map(device => (
                  device.Vlan === vlan.VlanRecordIdentifier && device.Status === 'connected' ? (
                    <Card key={device.DeviceRecordIdentifier} className="device" onClick={() => this.showModal(device.DeviceRecordIdentifier)}>
                      <Card.Body>
                        <Card.Title>{device.DeviceName}</Card.Title>
                        <Card.Text>
                          <div className="category">
                            MAC:
                            <div className="details">{device.MacAddress}</div>
                          </div>
                          <div className="category">
                            Connected Since:
                            <div className="details">{new Date(device.ConnectedSince).toLocaleDateString()}</div>
                          </div>
                        </Card.Text>
                      </Card.Body>
                    </Card>
                  ) : (
                    device.Vlan === vlan.VlanRecordIdentifier && device.Status === 'disconnected' ? (
                      offlineDevices = true
                    ) : (null)
                  )
                ))}

                {offlineDevices ? (
                  <div id="not-connected-text" className="not-connected">Currently Offline: </div>
                ) : (null)
                }

                {this.state.devices.map(device => (
                  device.Vlan === vlan.VlanRecordIdentifier && device.Status === 'disconnected' ? (
                    <Card key={device.DeviceRecordIdentifier} className="disconnected" onClick={() => this.showModal(device.DeviceRecordIdentifier, this.state.vlans)}>
                      <Card.Body>
                        <Card.Title>{device.DeviceName}</Card.Title>
                        <Card.Text>
                          <div className="category">
                            MAC:
                            <div className="details">{device.MacAddress}</div>
                          </div>
                          <div className="category">
                            Connected Since:
                            <div className="details">N/A</div>
                          </div>
                        </Card.Text>
                      </Card.Body>
                    </Card>
                  ) : (null)
                ))}
              </Container>
            </Col>
          })}
        </Row>
      </div >
    );
  }
}

export default Devices;