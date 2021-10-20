import React from 'react';
import './css/Analytics.css'
import { Container, Col, Row } from 'react-bootstrap';
import logo from './images/logo.png';
import {
    BarChart, Bar, XAxis, YAxis, Tooltip, Legend, ResponsiveContainer, Label
} from 'recharts';

const data = [
    { name: "Computers", Upload: 500, Download: 3250 },
    { name: "Smart Home", Upload: 560, Download: 1800 },
    { name: "Gaming/TV", Upload: 100, Download: 700 },
    { name: "Guest", Upload: 320, Download: 2791 }
  ];

class Analytics extends React.Component {

    render() {
        return (
            <div>
                <div id='watermark-container'>
                    <img src={logo} id='background-logo' alt='Black Bear watermark logo' />
                </div>
                <Container id="analytics-container">
                    <Row>
                        <Col>
                            <Row><div id="analytics-header">Upload Speed</div></Row>
                            <Row id="analytics-stat">
                                <div id="analytics-num">50</div>
                                <div id="analytics-unit">mbps</div>
                            </Row>
                        </Col>
                        <Col>
                            <Row><div id="analytics-header">Upload Data Today</div></Row>
                            <Row id="analytics-stat">
                                <div id="analytics-num">1.3</div>
                                <div id="analytics-unit">GB</div>
                            </Row>
                        </Col>
                        <Col>
                            <Row><div id="analytics-header">Download Speed</div></Row>
                            <Row id="analytics-stat">
                                <div id="analytics-num">280</div>
                                <div id="analytics-unit">mbps</div>
                            </Row>
                        </Col>
                        <Col>
                            <Row><div id="analytics-header">Download Data Today</div></Row>
                            <Row id="analytics-stat">
                                <div id="analytics-num">5.8</div>
                                <div id="analytics-unit">GB</div>
                            </Row>
                        </Col>
                        <Col>
                            <Row><div id="analytics-header">Online Devices</div></Row>
                            <Row id="analytics-stat">
                                <div id="analytics-num">43</div>
                                <div id="analytics-unit"></div>
                            </Row>
                        </Col>
                        <Col>
                            <Row><div id="analytics-header">Network Status</div></Row>
                            <Row id="analytics-stat">
                                <div id="analytics-word">Weak</div>
                            </Row>
                        </Col>
                    </Row>
                    <Row>
                        <Container>
                            <div style={{height: "50vh", marginTop: "3em", boxSizing: "border-box"}}>
                            <ResponsiveContainer width="100%" height="100%">
                                <BarChart data={data}>
                                    <XAxis dataKey="name" stroke="#cfcfcf"/>
                                    <YAxis stroke="#cfcfcf">
                                        <Label angle={-90} position="insideLeft" fill="#cfcfcf" offset={1}>
                                            Megabits/Second
                                        </Label>
                                    </YAxis>
                                    <Tooltip />
                                    <Legend />
                                    <Bar dataKey="Download" fill="#8ce6ba" />
                                    <Bar dataKey="Upload" fill="#23b36d" />
                                </BarChart>
                            </ResponsiveContainer>
                            </div>
                        </Container>
                    </Row>
                </Container>
            </div >
        );
    }
}

export default Analytics;