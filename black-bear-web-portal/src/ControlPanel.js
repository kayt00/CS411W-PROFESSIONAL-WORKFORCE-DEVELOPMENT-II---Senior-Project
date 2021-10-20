import React from 'react';
import './css/ControlPanel.css';
import { Button, Container, Form } from 'react-bootstrap';
import logo from './images/logo-dark.png';

function clearStorage() {
  localStorage.clear();
}

class ControlPanel extends React.Component {
  render() {
    return (
      <div>
        <div id='watermark-container'>
          <img src={logo} id='background-logo' alt='Black Bear watermark logo' />
        </div>
        <Container>
          <Form className="control-panel">
            <Form.Group>
              <Button onClick={clearStorage}>Clear Local Storage</Button>
            </Form.Group>
          </Form>
        </Container>
      </div>
    );
  }
}

export default ControlPanel;