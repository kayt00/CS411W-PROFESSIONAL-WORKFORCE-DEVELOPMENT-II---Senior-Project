import React from 'react';
import './css/App.css';
import { BrowserRouter, Redirect, Route, Switch } from 'react-router-dom';
import Advanced from './Advanced.js';
import Analytics from './Analytics.js';
import ControlPanel from './ControlPanel.js';
import Devices from './Devices.js';
import LoginForm from './LoginForm.js';
import MainNavbar from './MainNavbar.js';
import Network from './Network.js';
import Profile from './Profile.js';
import TwoFactorFlow from './components/TwoFactorFlow';

let LOCAL_STORAGE_USERNAME_KEY = "username"
let LOCAL_STORAGE_TOKEN_KEY = "auth_token" 
let LOCAL_STORAGE_USER_ROLE_KEY = "user_role";

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      deviceName1: "InitialText",
      loggedIn: localStorage.getItem(LOCAL_STORAGE_TOKEN_KEY) !== null,
      username: localStorage.getItem(LOCAL_STORAGE_USERNAME_KEY),
      token: localStorage.getItem(LOCAL_STORAGE_TOKEN_KEY),
      userRole: localStorage.getItem(LOCAL_STORAGE_USER_ROLE_KEY)
    };
    this.changeDevice = this.changeDevice.bind(this);
  }

  changeDevice(text) {
    this.setState({
      deviceName1: text,
    })
  }

  render() {
    return (
        <BrowserRouter>
          <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"></link>
            {!this.state.loggedIn ?
              <Switch>
                <Route exact path="/" render = { props => 
                  (<LoginForm {...props} onSuccessfulLogin = {(token, username, userRole) => {
                    this.setState({loggedIn: true, username: username, token: token, userRole: userRole});
                    localStorage.setItem(LOCAL_STORAGE_USERNAME_KEY, username);
                    localStorage.setItem(LOCAL_STORAGE_TOKEN_KEY, token);
                    localStorage.setItem(LOCAL_STORAGE_USER_ROLE_KEY, userRole);
                  }}/>)
                  }>
                </Route>
                <Route>
                <Redirect to="/"/>
                </Route>
              </Switch>
              :
              <>
              <MainNavbar />
              <TwoFactorFlow onEnd={() => {}} />
              <Switch>
                <Route exact path="/">
                  <Redirect to="/devices"/>
                </Route>
                <Route
                exact path="/devices"
                render={props => (<Devices {...props} deviceName1={this.state.deviceName1} />)}
                />
                <Route exact path="/network" component={Network} />
                <Route exact path="/analytics" component={Analytics} />
                <Route exact path="/advanced" component={Advanced} />
                <Route exact path="/control" component={ControlPanel} />
                <Route exact path="/profile">
                  <Profile onLogout={() => {
                    localStorage.removeItem(LOCAL_STORAGE_USERNAME_KEY);
                    localStorage.removeItem(LOCAL_STORAGE_TOKEN_KEY);
                    this.setState({username: "", token: "", loggedIn: false});
                  }}/>
                </Route>
              </Switch>
              </>
            }
        </BrowserRouter>
    );
  }
}

export default App;