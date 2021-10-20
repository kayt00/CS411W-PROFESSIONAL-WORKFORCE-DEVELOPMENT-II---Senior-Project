import React from "react";
import { Modal } from "react-bootstrap";

class AddVlanModal extends React.Component {

  constructor(props) {
    super(props);


    this.submitNewVlan = this.submitNewVlan.bind(this);

    this.state = {
      name: "",
      uploadLimit: null,
      downloadLimit: null,
      peakUpload: null,
      peakDownload: null
    };
  }

  submitNewVlan = () => {
    this.props.restTemplate.post('/vlan/add', this.state)
    .then(response => {
      this.props.hideModal(true);
    })
    .catch(e => console.log(e));
  }

  render() {
    return ( this.props.showing?
      <Modal show={this.props.showing} onHide={this.props.hideModal} centered>
        <Modal.Header closeButton>
          <Modal.Title>Add Subdivision</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="modal-category">
            Subdivision name:
            <input
              id="email-input"
              type="text"
              value={this.state.name}
              onChange={(event) => {
                this.setState({
                  name: event.target.value
                });
              }}
            />
          </div>
          <div className="modal-category">
            Daily Upload Limit
            <input
              id="email-input"
              type="number"
              value={this.state.uploadLimit}
              onChange={(event) => {
                this.setState({
                  uploadLimit: event.target.value
                });
              }}
            />
            MB
          </div>
          <div className="modal-category">
            Daily Download Limit
            <input
              id="email-input"
              type="number"
              value={this.state.downloadLimit}
              onChange={(event) => {
                this.setState({
                  downloadLimit: event.target.value
                });
              }}
            />
            MB
          </div>
          <div className="modal-category">
            Peak Upload Limit
            <input
              id="email-input"
              type="number"
              value={this.state.peakUpload}
              onChange={(event) => {
                this.setState({
                  peakUpload: event.target.value
                });
              }}
            />
            MBps
          </div>
          <div className="modal-category">
            Peak Download Limit
            <input
              id="email-input"
              type="number"
              value={this.state.peakDownload}
              onChange={(event) => {
                this.setState({
                  peakDownload: event.target.value
                });
              }}
            />
            MBps
          </div>
          
        
        </Modal.Body>
        <Modal.Footer>
          <button
            id="approve-button"
            onClick={() => {
              this.submitNewVlan();
            }}
            disabled={
              this.state.name === ""
            }
          >
            Add Subdivision
          </button>
        </Modal.Footer>
      </Modal>
      : ""
    );
  }
}

export default AddVlanModal;
