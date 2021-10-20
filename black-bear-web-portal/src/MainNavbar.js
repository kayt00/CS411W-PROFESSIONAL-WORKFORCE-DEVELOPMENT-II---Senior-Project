import React from 'react';
import { Image, Nav, Navbar } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import './css/MainNavbar.css'
import logo from './images/logo.png';

class MainNavbar extends React.Component {
  render() {
    return (
      <div>
        <Navbar variant="dark" style={{ padding: "0" }}>
          <Navbar.Brand as={Link} to="/" style={{ padding: "0" }}>
            <Image src={logo} className='Image' style={{ height: "2.6em", padding: ".2em", backgroundColor: "grey", borderBottomRightRadius: "0.2em" }} />
          </Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="mr-auto">
              <Nav.Link as={Link} to="/devices">Devices</Nav.Link>
              <Nav.Link as={Link} to="/network">Network</Nav.Link>
              <Nav.Link as={Link} to="/analytics">Analytics</Nav.Link>
              <Nav.Link as={Link} to="/advanced">Advanced</Nav.Link>

              {/* Access this by inputting the URL for now
                            <Nav.Link as={Link} to="/control">Admin Control Panel</Nav.Link>*/}

              <Nav.Link as={Link} to="/profile" className="material-icons" id="profile-link">person</Nav.Link>
            </Nav>
          </Navbar.Collapse>
        </Navbar>
      </div>
    );
  }
}


export default MainNavbar;
