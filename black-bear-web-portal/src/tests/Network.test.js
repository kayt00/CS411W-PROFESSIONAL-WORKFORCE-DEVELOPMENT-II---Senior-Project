import { render, fireEvent, screen, waitFor } from '@testing-library/react';
import renderer from 'react-test-renderer';
import Network, { AddUserModal } from '../Network.js';
import axios from 'axios';
import { Simulate } from 'react-dom/test-utils';

test('should not display Add User modal before click', () => {
    const subject = render(<Network/>);

    expect(subject.container.querySelectorAll('#add-user-button').length).toEqual(1);
    expect(subject.queryAllByTestId('approve-button').length).toEqual(0);
});

test('should not display VLAN modal before click', () => {
    const subject = render(<Network/>);

    expect(subject.container.querySelectorAll('.vlan-card').length).toEqual(3);
    expect(subject.queryAllByTestId('black-bear-modal').length).toEqual(0);
});

test('Should display Add User modal on click', async () => {
    const subject = render(<Network/>);

    expect(screen.getAllByText('Add').length).toBeTruthy();

    var items;

    try {
        items = await screen.findAllByText('Add User');
    }   catch(error) {
        items = [];
    }

    expect(items.length).toEqual(0);

    fireEvent.click(screen.getAllByText('Add')[0]);

    const items2 = await screen.findAllByText('Add User');
    
    expect(items2.length).toEqual(2);
});

test('Should display VLAN modal on click', async () => {
    const subject = render(<Network/>);

    expect(screen.getAllByText('Smart Home').length).toBeTruthy();

    var items;

    try {
        items = await screen.findAllByText('Remove This Subdivision');
    }   catch(error) {
        items = [];
    }

    expect(items.length).toEqual(0);

    fireEvent.click(screen.getAllByText('Smart Home')[0]);

    const items2 = await screen.findAllByText('Remove This Subdivision');
    
    expect(items2.length).toEqual(1);
});