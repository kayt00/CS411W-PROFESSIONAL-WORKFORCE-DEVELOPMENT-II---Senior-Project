import React from 'react';
import { Col, Container, Form, Image, Modal, Row } from 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import './css/LoginForm.css'
import logo from './images/logo-dark.png';
import axios from 'axios';

const restTemplate = axios.create({
  baseURL: process.env["REACT_APP_BACKEND_URL"],
  timeout: 100000
});

class AdminModal extends React.Component {
  constructor(props) {
    super(props);

    this.handleAdminCreation = this.handleAdminCreation.bind(this);

    this.state = {
      username: "",
      password: "",
      confirmation: "",
      error: false
    };
  }
  handleAdminCreation() {
    restTemplate.post("/auth/register-initial-admin",
      {
        firstName: "testFirstName",
        lastName: "testLastName",
        username: this.state.username,
        email: "testEmail@email.com",
        password: this.state.password,
        phone: "012-345-6789"
      }
    )
      .then((response) => {
        if (response.data != null) {
          this.setState({ error: false });
          this.props.hideModal();
        }
        else {
          this.setState({ error: true });
        }
      })
      .catch((response) => {
        console.log("Error with login process: " + response);
      });
  }
  render() {
    return (
      <Modal
        size="lg"
        show={this.props.showing}
        backdrop="static"
        onHide={this.props.hideModal}
        centered
        style={{ "text-align": "center", display: "block" }}
      >
        <Modal.Header id="admin-modal-header" style={{"margin-bottom": "1em"}}>
          <Modal.Title>Welcome to Black Bear!</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form className="login-form" style={{display: "block", padding: "auto", width: "60%", "margin-bottom": "4em", "margin-left": "auto", "margin-right": "auto"}}>
            <Form.Label>Create your admin account!</Form.Label>
            <Form.Group>
              <Form.Control
                onChange={(event) => {
                  this.setState({ username: event.target.value });
                }}
                placeholder="Username"
                isInvalid={this.state.error}
              ></Form.Control>
            </Form.Group>
            <Form.Group>
              <Form.Control onChange={(event) => {
                this.setState({ password: event.target.value });
              }}
                placeholder="Password"
                value={this.state.password}
                type="password"
                isInvalid={this.state.error}
              ></Form.Control>
            </Form.Group>
            <Form.Group>
              <Form.Control
                onChange={(event) => {
                  this.setState({ confirmation: event.target.value });
                }}
                placeholder="Confirmation"
                value={this.state.confirmation}
                type="password"
                isInvalid={this.state.error}
              ></Form.Control>
            </Form.Group>
          </Form>

          <button
            onClick={() => {
              if (this.state.username !== "" && 
                  this.state.password !== "" && 
                  this.state.password === this.state.confirmation) {
                this.handleAdminCreation();
              }
            }}
            id="submit"
            type="submit"
            disabled={this.state.username === "" && this.state.password === ""}
            className={this.state.username === "" && this.state.password === "" ? "login-button-disabled" : "login-button"}>
            Create Admin Account
          </button>

        </Modal.Body>
      </Modal >
    );
  }
}

class LoginForm extends React.Component {
  constructor(props) {
    super(props);

    this.showModal = this.showModal.bind(this)
    this.hideModal = this.hideModal.bind(this)
    this.handleLoginAttempt = this.handleLoginAttempt.bind(this);
    this.checkAdminExists = this.checkAdminExists.bind(this);

    this.state = {
      adminExists: "",
      modalShowing: false,
      username: "",
      password: "",
      error: false
    };
  }
  componentDidMount () {
    this.checkAdminExists()
  }
  showModal = () => {
    this.setState({ modalShowing: true });
    console.log("card click");
  }
  hideModal = () => {
    this.setState({ modalShowing: false });
    console.log("clicked hide");
  }
  handleLoginAttempt() {
    this.setState({error: false});
    restTemplate.post("/auth/login",
      {
        username: this.state.username,
        password: this.state.password
      }
    )
      .then((response) => {
        if (response.data != null) {
          this.setState({ error: false });
          this.props.onSuccessfulLogin(response.data.token, this.state.username, response.data.userRole);
        }
      })
      .catch(ex => {
        if (ex.response){
          if (ex.response.status === 401)
            this.setState({ error: true });
        }
        console.log("Error with login process: " + ex);
      });
  }
  checkAdminExists() {
    restTemplate.get("/user/admin-user-exists")
    .then((response) => {
      if (response.data != null) {
        this.setState({ error: false });
        this.setState({ modalShowing: !response.data})
      }
      else {
        this.setState({ error: true });
      }
    })
    .catch((response) => {
      console.log("Error with login process: " + response);
    });
  }
  render() {
    return (
      <div style={{ marginTop: "2%" }} className="login-page login-form">
        <AdminModal showing={this.state.modalShowing} showModal={this.showModal} hideModal={this.hideModal} />
        <Container style={{ width: "38em", marginBottom: "2em" }}>
          <Row>
            <Col><Image src={logo} style={{ height: "17em" }} /></Col>
            <Col className="logo-text">
              <Row style={{ marginTop: "1em", fontSize: "4em" }}>Black Bear</Row>
              <Row style={{ fontSize: "2em", fontStyle: "italic" }}>Home Guardian</Row>
            </Col>
          </Row>
        </Container>
        <Container style={{ width: "25em", display: "block" }}>
          <Form className="login-form">
            <Form.Group>
              <Form.Label>Log in to continue</Form.Label>
              <Form.Control
                onChange={(event) => {
                  this.setState({ username: event.target.value });
                }}
                placeholder="Username"
                isInvalid={this.state.error}
              ></Form.Control>
            </Form.Group>
            <Form.Group>
              <Form.Control onChange={(event) => {
                this.setState({ password: event.target.value });
              }}
                placeholder="Password"
                value={this.state.password}
                type="password"
                isInvalid={this.state.error}
              ></Form.Control>
            </Form.Group>

            <div id="incorrect-credentials-message">{this.state.error ? "Incorrect Credentials" : ""}</div>

          </Form>

          <button
            onClick={() => {
              if (this.state.username !== "" || this.state.password !== "") {
                this.handleLoginAttempt();
              }
            }}
            id="submit"
            type="submit"
            disabled={this.state.username === "" && this.state.password === ""}
            className={this.state.username === "" && this.state.password === "" ? "login-button-disabled" : "login-button"}>
            Login
                        </button>
          <a className="password-button" href="#forgot-password">Forgot Password?</a>
        </Container>
      </div>
    );
  }
}

export default LoginForm;
