import React from 'react';
import '../css/TwoFactorFlow.css';
import LabeledField from './LabeledField.js';
import axios from 'axios';
import guestLogo from '../images/icons8-traveler-90.svg';
import computer from '../images/icons8-mouse-pointer-90.png';
import phone from '../images/icons8-iphone-90.png';
import keys from '../images/icons8-bunch-of-keys-90.png';
import coffee from '../images/icons8-coffee-maker-90.png';
import lightBulb from '../images/icons8-greentech-90.png';
import camera from '../images/icons8-wall-mount-camera-90.png';
import retroTv from '../images/icons8-retro-tv-90.png';
import gameController from '../images/icons8-game-controller-90.png';
import xBox from '../images/icons8-xbox-120.png';
import tv from '../images/icons8-tv-show-90.png';


let LOCAL_STORAGE_TOKEN_KEY = "auth_token" 

var restTemplate;

class TwoFactorFlow extends React.Component {
    constructor(props) {
        super(props);

        this.waitBeforeResetingState = this.waitBeforeResetingState.bind(this);
        this.buildRestTemplate = this.buildRestTemplate.bind(this);
        this.checkForPendingDevices = this.checkForPendingDevices.bind(this);
        this.fetchVlans = this.fetchVlans.bind(this);
        this.getVlanById = this.getVlanById.bind(this);
        this.sendApproval = this.sendApproval.bind(this);
        this.sendDenial = this.sendDenial.bind(this);
        this.generateVlanImages = this.generateVlanImages.bind(this)

        this.state = {
            // 0 -> nothing showing but checking for devices
            // 1 -> initial notification
            // 2 -> info modal
            // 3 -> VLAN selection modal
            // 4 -> Confirmation modal
            // 5 -> final notification
            // 6 -> component is unmounting and should stop checking for devices
            currentFlowStatus: 0,
            device: null,
            selectedVlan: null,
            vlans: null
        };
    }

    buildRestTemplate = () => {
        const authHeader = localStorage.getItem(LOCAL_STORAGE_TOKEN_KEY);
        restTemplate = axios.create({
        baseURL: process.env["REACT_APP_BACKEND_URL"],
        timeout: 100000,
        headers: { Authorization: authHeader}
        }); 
    }

    checkForPendingDevices = async () => {
        while(this.state.currentFlowStatus === 0 && restTemplate != null){
            restTemplate.get('/device/pending')
            .then(response => {
                if (response.data.length > 0) {
                    this.setState({currentFlowStatus: 1, device: response.data[0]});
                }
            })
            .catch(e => {
                console.log("error fetching MFA-ready devices: " + e);
                this.buildRestTemplate();
            });
            await new Promise(r => setTimeout(r, 8000));
        }
    }

    componentDidMount = () => {
        this.buildRestTemplate();
        this.checkForPendingDevices();
    }

    componentDidUpdate = (prevProps, prevState) => {
        if (prevState.currentFlowStatus !== this.state.currentFlowStatus && this.state.currentFlowStatus === 0) {
            this.checkForPendingDevices();
        }
    }

    componentWillUnmount = () => {
        restTemplate = null;
    }

    fetchVlans = () => {
        restTemplate.get('/vlan/all')
        .then(response => {
            this.setState({vlans: response.data});
        })
        .catch(e => {});
    }

    waitBeforeResetingState = async () => {
        await new Promise(r => setTimeout(r, 2000));
        this.setState({
            currentFlowStatus: 0,
            selectedVlan: null
        });
        this.props.onEnd();
    }

    getVlanById = (id) => {
        return this.state.vlans == null ? "" : this.state.vlans.find(it => {return it.VlanRecordIdentifier === id });
    }

    sendApproval = (vlan, onFinished) => {
        restTemplate.post('/device/approve', 
            {
                deviceId: this.state.device.DeviceRecordIdentifier,
                vlan: vlan
            }
        )
        .then(response => {
            this.setState({currentFlowStatus: 5});
        })
        .catch(e => {
            console.log("Error while sending approval: " + e);
        });
    }

    sendDenial = () => {
        restTemplate.delete('/device/'+this.state.device.DeviceRecordIdentifier)
        .then(() => {
            this.setState({currentFlowStatus: 0});
        })
        .catch(e => {
            console.log("Error while sending denial: " + e);
        });
    }

    generateVlanImages = (vlanName) => {
        let vlan = String(vlanName.toLowerCase())
        if (vlan.includes('computer')){
            return <>
                <img src={computer} alt="icon of a computer"/>
                <img src={phone} alt="icon of a phone"/>
            </>
        }
        else if (vlan.includes('computer')){
            return <>
                <img src={computer} alt="icon of a computer"/>
                <img src={phone} alt="icon of a phone"/>
            </>
        }
        else if (vlan.includes('smart')){
            return <>
                <img src={lightBulb} alt="icon of a light bulb"/>
                <img src={coffee} alt="icon of coffee maker"/>
                <img src={keys} alt="icon of keys"/>
                <img src={camera} alt="icon of a camera"/>
            </>;
        }
        else if (vlan.includes('gaming')){
            return <>
                <img src={xBox} alt="icon of an xBox"/>
                <img src={gameController} alt="icon of a game controller"/>
                <img src={tv} alt="icon of TV"/>
                <img src={retroTv} alt="icon of a retro TV"/>
            </>
        }
        else return "";
    }

    render() {
        switch(this.state.currentFlowStatus) {
            case 0:
                return (<></>);
            case 1:
                return (
                    <>
                        <div className="two-factor-box initial-notification">
                            <h1>{this.state.device.DeviceName}</h1>
                            <i>Would like to join your network</i>
                            <span id="view-button"
                                onClick={() => {
                                    this.setState({currentFlowStatus: 2});
                                }}
                            >View</span>
                            <span id="deny-button"
                                onClick={() => {
                                    this.sendDenial();
                                }}
                            >Deny</span>
                        </div>
                    </>
                );
            case 2:
                return (
                    <>
                        <div className="full-screen-blur">
                            <div className="two-factor-box" id="info-modal">
                                <h1>{this.state.device.DeviceName}</h1>
                                <i>Would like to join your network</i>
                                {/*TODO must add logic to get this information from props*/}
                                <LabeledField label="Manufacturer" text={this.state.device.Manufacturer}/>
                                <LabeledField label="Device OS" text={this.state.device.OperatingSystem}/>
                                <LabeledField label="First Seen" text={this.state.device.CreationTimestamp}/>
                                <LabeledField label="Last Seen" text={this.state.device.LastConnected == null ? "never" : this.state.device.LastConnected}/>
                                <div>
                                    <button id="approve-button"
                                            onClick={() => {
                                                this.fetchVlans();
                                                this.setState({currentFlowStatus: 3});
                                            }}
                                    >Approve</button>
                                    <button id="second-deny-button"
                                            onClick={() => {
                                                this.sendDenial();
                                            }}
                                    >
                                        Deny
                                    </button>
                                </div>
                            </div>
                        </div>
                    </>
                );
            case 3:
                return (
                    <>
                        <div className="full-screen-blur">
                            <div className="two-factor-box" id="vlan-modal">
                                <h1>Subdivision</h1>
                                <i>Where should {this.state.device.DeviceName} be assigned?</i>
                                <div className="small-vlan-container">
                                    {this.state.vlans == null ? "" : this.state.vlans.map(it => it.VlanRecordIdentifier === 1 ? "" : (
                                    <span key={it.VlanRecordIdentifier} className="small-vlan-column">
                                        <h4>
                                            {it.VlanName}
                                        </h4>
                                        <div className="small-vlan-button"
                                            onClick={() => {
                                                this.setState({
                                                    currentFlowStatus: 4,
                                                    selectedVlan: it.VlanRecordIdentifier
                                                });
                                            }}
                                        >
                                            
                                        {this.generateVlanImages(it.VlanName)}
                                            
                                        </div>
                                    </span>
                                    ))}
                                </div>
                                <h2>{this.state.vlans == null? "" : this.state.vlans.find(it => {return it.VlanRecordIdentifier === 1}).VlanName}</h2>
                                <div id="guest-vlan-button"
                                    onClick={() => {
                                        this.setState({
                                            selectedVlan: 1
                                        });
                                        this.sendApproval(1);
                                    }}
                                >
                                    <img style={{height: "80%", marginTop: "5%"}} src={guestLogo} alt="Icon of a traveler"/>
                                </div>
                                <button className="green-link-button"
                                        onClick={() => {
                                            this.setState({currentFlowStatus: 2});
                                        }}
                                >
                                    <span className="material-icons">chevron_left</span>
                                    Back
                                </button>
                            </div>
                        </div>
                    </>
                );
            case 4:
                return (
                    <>
                        <div className="full-screen-blur">
                            <div className="two-factor-box" id="confirmation-modal">
                                <h1>Add {this.state.device.DeviceName} to {this.getVlanById(this.state.selectedVlan).VlanName}?</h1>
                                <i>
                                    Only do this if the device will need to be on your network often.
                                    Use the Guest subdivision for any devices that aren't yours.
                                </i>
                                <div>
                                    <button id="confirm-modal-back"
                                            onClick={() => {
                                                this.setState({
                                                    currentFlowStatus: 3
                                                });
                                            }}
                                    >
                                        <span className="icon-font-size material-icons">chevron_left</span>
                                        Back
                                    </button>
                                    <button className="green-link-button" id="confirm-modal-confirm"
                                            onClick={() => {
                                                this.sendApproval(this.state.selectedVlan);
                                            }}
                                    >
                                        Confirm
                                        <span className="icon-font-size material-icons">chevron_right</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </>
                );
            case 5:
                this.waitBeforeResetingState();
                return (
                    <>
                        
                        <div className="two-factor-box initial-notification">
                            <h1>Success</h1>
                            <i>{this.state.device.DeviceName} has been added to {this.getVlanById(this.state.selectedVlan)?.VlanName}.</i>
                        </div>
                    </>
                );
            default:
                return (<></>);
        }
    }
}

export default TwoFactorFlow;