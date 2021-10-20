import React from 'react';
import './css/Network.css';
import arrow from './images/arrow.png';
import logo from './images/logo-dark.png';
import { Card, Image, Modal, Dropdown } from 'react-bootstrap';
import LabeledField from './components/LabeledField';
import axios from 'axios';
import AddVlanModal from './components/AddVlanModal';
//let LOCAL_STORAGE_USERNAME_KEY = "username"
let LOCAL_STORAGE_TOKEN_KEY = "auth_token" 
let LOCAL_STORAGE_USER_ROLE_KEY = "user_role";

let restTemplate;

class NetworkModal extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      editingName: false,
      newName: null
    }

    this.removeVlan = this.removeVlan.bind(this);
    this.renameVlan = this.renameVlan.bind(this);
  }


  removeVlan = (relocateDevicesTo) => {
    restTemplate.post('/vlan/remove', {
      id: this.props.vlan.VlanRecordIdentifier,
      relocateDevicesTo: relocateDevicesTo
    })
    .then(response => {
      this.props.hideModal(true);
    })
  }

  renameVlan = () => {
    restTemplate.post('/vlan/rename', {
      id: this.props.vlan.VlanRecordIdentifier,
      name: this.state.newName
    })
    .then(response => {
      this.setState({newName: null, editingName: false});
      this.props.requestVlans();
    })
    .catch(e => console.log(e))
  }

  render() {
    return this.props.showing ? (
      <Modal
        id="black-bear-modal"
        show={this.props.showing}
        onHide={this.props.hideModal}
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title>
            {this.state.editingName ? (
              <>
                <input id="email-input" 
                      style={{fontSize: "medium"}}
                      value={this.state.newName}
                      onChange={(event) => {this.setState({newName: event.target.value});}}
                />
                <button className="green-link-button"
                      style={{ fontSize: "large", marginLeft: "1em" }}
                      onClick={() => {this.renameVlan()}}
                >
                  save
                </button>
                <button className="red-link-button"
                      style={{ fontSize: "large", marginLeft: "1em" }}
                      onClick={() => {this.setState({editingName: false, newName: null});}}
                >
                  Cancel
                </button>
              </>
            ) : (
              <>
                <div>
                  <span>{this.props.vlan.VlanName}</span>
                  {this.props.modifiable ? (
                    <button
                      className="green-link-button"
                      style={{ fontSize: "large", marginLeft: "1em" }}
                      onClick={() => {this.setState({editingName: true});}}
                    >
                      Edit Name
                    </button>
                  ) : ("")
                  }
                </div>
              </>
              
            )}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="modal-category">
            Created By:
            <div className="details">{this.props.vlan.Creator}</div>
          </div>
          <div className="modal-category">
            Created On:
            <div className="details">{this.props.vlan.CreationTimestamp}</div>
          </div>
          <div className="modal-category">
            Average Daily Upload Traffic:
            {/* <div className="details">3.6 MB</div> */}
            <button className="modal-button">
              {this.props.vlan.DownloadLimitMB == null
                ? "Add Limit"
                : "Limit: " + this.props.vlan.UploadLimitMB + "MB"}
            </button>
          </div>
          <div className="modal-category">
            Average Daily Download Traffic:
            {/* <div className="details">538.2 MB</div> */}
            <button className="modal-button">
              {this.props.vlan.DownloadLimitMB == null
                ? "Add Limit"
                : "Limit: " + this.props.vlan.DownloadLimitMB + "MB"}
            </button>
          </div>
          <div className="modal-category">
            Peak Upload Bandwidth:
            {/* <div className="details">20 mbps</div> */}
            <button className="modal-button">
              {this.props.vlan.DownloadLimitMB == null
                ? "Add Limit"
                : "Limit: " + this.props.vlan.PeakUploadLimitMBps + "MBps"}
            </button>
          </div>
          <div className="modal-category">
            Peak Download Bandwidth:
            {/* <div className="details">100 mbps</div> */}
            <button className="modal-button">
              {this.props.vlan.DownloadLimitMB == null
                ? "Add Limit"
                : "Limit: " + this.props.vlan.PeakDownloadLimitMBps + "MBps"}
            </button>
          </div>
        </Modal.Body>
        <Modal.Footer>
          {this.props.modifiable ? (
            <Dropdown>
              <Dropdown.Toggle id="remove-button">
                Remove Subdivision
              </Dropdown.Toggle>
              <Dropdown.Menu>
                <Dropdown.ItemText>
                  <i>Relocate Devices to:</i>
                </Dropdown.ItemText>
                {this.props.vlans.map((vlan) => {
                  return this.props.vlan.VlanRecordIdentifier !==
                    vlan.VlanRecordIdentifier ? (
                    <Dropdown.Item
                      onClick={() => this.removeVlan(vlan.VlanRecordIdentifier)}
                    >
                      {vlan.VlanName}
                    </Dropdown.Item>
                  ) : (
                    ""
                  );
                })}
              </Dropdown.Menu>
            </Dropdown>
          ) : (
            ""
          )}
        </Modal.Footer>
      </Modal>
    ) : (
      ""
    );
  }
}

class AddUserModal extends React.Component {
  constructor(props){
    super(props);

    this.submitNewUser = this.submitNewUser.bind(this);

    this.state = {
      email: "",
      validEmail: true,
      userType: null
    }
  }

  submitNewUser() {
    if (restTemplate != null){
      restTemplate.post('/auth/add-user', {
        email: this.state.email,
        userRole: String(this.state.userType).toUpperCase()
      }).then(response => {
        console.log("Succcessfully added user");
        this.setState({email: "", userType: null});
        this.props.hideModal(true);
      })
      .catch(e => {
        console.log(e);
      });
    }
  }

  render(){
    return(
      <Modal
        show={this.props.showing}
        onHide={this.props.hideModal}
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title>Add User</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="modal-category">
            New user email:
            <input id="email-input" 
                    type="email"
                    value={this.state.email}
                    style={this.state.validEmail ? {} : {outline: "solid 1px red"}}
                    onChange={(event) => {
                        this.setState({
                          email: event.target.value,
                          validEmail: (/\S+@\S+\.\S+/).test(event.target.value) || event.target.value === ""
                        });

                    }}
            ></input>
            {this.state.validEmail? ""
            : <i style={{color: "red"}}>Invalid Email</i>
            }
            
          </div>
          <div className="modal-category">
            
            User Type*:
              <span className="user-type-radio">
              <input type="radio" id="admin" name="user-type"
              onChange={() => {
                this.setState({userType: 'ADMIN'});
              }}
              />
              <label for="ADMIN">Admin</label>
              </span>

              <span className="user-type-radio">
              <input type="radio" id="std-user" name="user-type"
              onChange={() => {
                this.setState({userType: 'STANDARD'});
              }}
              />
              <label for="STANDARD">Standard User</label>
              </span>
              
          </div>
          <i>
          *Admin users have unlimited permissions. 
          Standard Users can only add guest devices. 
          They cannot make any other changes to the network.
          </i>
        </Modal.Body>
        <Modal.Footer>
          <button id="approve-button"
          onClick={() => {
            this.submitNewUser();
          }}
          disabled = {!this.state.validEmail || this.state.email === "" || this.state.userType == null || this.state.userType === ""}
          >Add User</button>
        </Modal.Footer>
      </Modal>
    );
  }
}

class Network extends React.Component {

  /*

  handleLoginAttempt() {
    restTemplate.post("/cgi-bin/luci/rpc/auth",
      {
        id: 1,
        method: "login",
        params: [
          this.state.username,
          this.state.password
        ]
      }
    )
      .then((response) => {
        if (response.data.result != null) {
          this.setState({ error: false });
          this.props.onSuccessfulLogin(response.data.result, this.state.username);
        }
        else {
          this.setState({ error: true });
        }
      })
      .catch((response) => {
        console.log("Error with login process: " + response);
      });
  }*/

  constructor(props) {
    super(props);
    this.state = {
      vlanModalShowing: false,
      activeVlan: null,
      addUserModalShowing: false,
      addVlanModalShowing: false,
      error: true,
      hostname: "",
      successNotificationShowing: false,
      successNotificationMessage: '',
      vlans: [],
      users: [],
      userRole: 'STANDARD'
    };

    this.showVlanModal = this.showVlanModal.bind(this);
    this.hideVlanModal = this.hideVlanModal.bind(this);
    this.requestHostname = this.requestHostname.bind(this);
    this.showUserModal = this.showUserModal.bind(this);
    this.requestVlans = this.requestVlans.bind(this);
    this.requestUsers = this.requestUsers.bind(this);
    this.generateUserLists = this.generateUserLists.bind(this);
    this.hideUserModal = this.hideUserModal.bind(this);
    this.showAddVlanModal = this.showAddVlanModal.bind(this);
    this.hideAddVlanModal = this.hideAddVlanModal.bind(this);
    this.determineModifiable = this.determineModifiable.bind(this);
  }

  componentDidMount() {
    const authHeader = localStorage.getItem(LOCAL_STORAGE_TOKEN_KEY);
    restTemplate = axios.create({
      baseURL: process.env["REACT_APP_BACKEND_URL"],
      timeout: 100000,
      headers: { Authorization: authHeader}
    });
    
    this.setState({userRole: localStorage.getItem(LOCAL_STORAGE_USER_ROLE_KEY)});
    this.requestVlans();

    if (localStorage.getItem(LOCAL_STORAGE_USER_ROLE_KEY) === 'ADMIN')
      this.requestUsers();

    // this.requestHostname();
  }

  requestUsers = () => {
    restTemplate.get('/user/all').then(response => {
      this.setState({users: response.data});
    })
    .catch(e => {
      console.log(e);
    });
  }

  requestVlans = () => {
    restTemplate.get('/vlan/all').then(response => {
      this.setState({vlans: response.data});
    }).catch(e => {
      console.log(e);
    });
  }

  requestHostname = () => {
    var postString = ("/cgi-bin/luci/rpc/uci?auth=" + localStorage.getItem("auth_token"));
    restTemplate.post(postString,
      {
        id: 1,
        method: "get",
        params: ["system", "@system[0]", "hostname"]
      }
    )
      .then((response) => {
        if (response.data.result != null) {
          this.setState({ error: false });
          this.setState({ hostname: response.data.result });
        }
        else {
          this.setState({ error: true });
        }
      })
      .catch((response) => {
        console.log("Error with login process: " + response);
      }
    );
  }

  showVlanModal = (vlanId) => {
    this.setState({ vlanModalShowing: true, activeVlan: vlanId });
    console.log("card click");
  }

  hideVlanModal = async (successful) => {
    this.setState({ 
      vlanModalShowing: false, 
      activeVlan: null,
      successNotificationShowing: successful == null ? false : successful,
      successNotificationMessage: successful == null ? "" : "VLAN successfully removed"
    });

    this.requestVlans();

    if (successful){
      await new Promise(r => setTimeout(r, 2000));
      
      this.setState({
        successNotificationShowing: false,
        successNotificationMessage: ""
      });
    }
    
    console.log("clicked hide");
  }

  showUserModal = () => {
    this.setState({addUserModalShowing: true});
  }

  determineModifiable = (vlanId) => {
    return [1,2,3,4].find(it => it === vlanId) === undefined
  }

  hideUserModal = async (successful) => {
  
    this.setState({
      addUserModalShowing: false,
      successNotificationShowing: successful == null ? false : successful,
      successNotificationMessage: successful == null ? "" : "User successfully added"
    });

    if (successful){
      await new Promise(r => setTimeout(r, 2000));
      
      this.setState({
        successNotificationShowing: false,
        successNotificationMessage: ""
      });
    }
  }

  showAddVlanModal = () => {
    this.setState({addVlanModalShowing: true});
  }

  hideAddVlanModal = async (successful) => {
    this.setState({
      addVlanModalShowing: false,
      successNotificationShowing: successful == null ? false : successful,
      successNotificationMessage: successful == null ? "" : "Subdivision successfully added"
    });

    this.requestVlans();

    if (successful) {
      await new Promise(r => setTimeout(r, 2000));
      
      this.setState({
        successNotificationShowing: false,
        successNotificationMessage: ""
      });
    }
  }

  generateUserLists = (type) => {
    return this.state.users
    .filter(it => it.UserRole === type)
    .map(it => String(it.Username) +' (' + String(it.Email) + ')')
    .join(', ');
  }

  render() {
    return (
      <div>
        {this.state.successNotificationShowing? 
        <>              
          <div className="two-factor-box initial-notification">
              <h1>Success</h1>
              <i>{this.state.successNotificationMessage}</i>
          </div>
        </> 
      : ""
      }
        <NetworkModal showing={this.state.vlanModalShowing} 
                      showModal={this.showVlanModal} 
                      hideModal={this.hideVlanModal} 
                      vlan={this.state.vlanModalShowing ? this.state.vlans.find(it => it.VlanRecordIdentifier === this.state.activeVlan) : null}
                      vlans={this.state.vlanModalShowing ? this.state.vlans : null}
                      modifiable={this.determineModifiable(this.state.activeVlan)}
                      requestVlans={this.requestVlans}
                      />
        <AddUserModal showing={this.state.addUserModalShowing} 
                      showModal={this.showUserModal} 
                      hideModal = {(successful) => {this.hideUserModal(successful)}}
                      />
        <AddVlanModal showing={this.state.addVlanModalShowing}
                      showModal={this.showAddVlanModal}
                      hideModal={this.hideAddVlanModal}
                      restTemplate={restTemplate}
                      />
        <div id='watermark-container'>
          <img src={logo} id='background-logo' alt='Black Bear watermark logo' />
        </div>
        <div className="section-header container">General <button className='green-link-button' style={{ fontSize: ".8em" }}>Edit</button></div>
        <div className="container" style={{ marginBottom: "40px" }}>
          <LabeledField label="Network Name" text={this.state.hostname} />
          <LabeledField label="Network PIN" text="314159" />
        </div>
        
        {this.state.userRole === 'ADMIN' ?
        <>
          <div className="section-header container">
            Users
            <button className='green-link-button' 
                    id='add-user-button'
                    style={{ fontSize: ".8em" }}
                    onClick={() => {
                      this.setState({addUserModalShowing: true});
                    }}
            >
              Add
              </button>
            </div>
          <div className="container" style={{ marginBottom: "40px" }}>
            <LabeledField label="Currently Registered as Admins" text={this.generateUserLists('ADMIN')} />
            <LabeledField label="Currently Registered as Standard Users" text={this.generateUserLists('STANDARD')} />
          </div>
        </>
        : ""
        }

        <div className="section-header container">Subdivisions</div>
        <div className="container" style={{ marginBottom: "40px" }}>
          {this.state.vlans.map(it => 
            <Card key={it.VlanRecordIdentifier} className="vlan-card" onClick={() => this.showVlanModal(it.VlanRecordIdentifier)}>
              <Card.Body>
                <Card.Title>{it.VlanName}<Image src={arrow} className="open-arrow"></Image></Card.Title>
              </Card.Body>
            </Card>
          )}
          {this.state.userRole === 'ADMIN' ? 
            <button className='green-link-button' 
                    style={{ marginTop: ".5em", fontSize: "1.2em" }}
                    onClick={() => {this.setState({addVlanModalShowing: true});}}
            >
              Add
            </button>
          : ""
          }
          
        </div>
      </div>
    );
  }
}
export { AddUserModal };
export default Network;