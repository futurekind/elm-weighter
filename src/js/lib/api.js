import { getAccessToken } from './dropbox'
const LOAD_URL = 'https://content.dropboxapi.com/1/files/auto'
const SAVE_URL = 'https://content.dropboxapi.com/1/files_put/auto';

export const load = () => fetch(`${LOAD_URL}/data.json`, {
    headers: {
        'Authorization': `Bearer ${getAccessToken()}`
    }
}).then(resp => resp.text())

export const save = data => {
    console.log(data);
    return fetch(`${SAVE_URL}/data.json`, {
        method: 'PUT',
        body: data,
        headers: {
            'Authorization': `Bearer ${getAccessToken()}`
        }
    })
}
