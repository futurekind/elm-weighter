const KEY = 'EW_AT';
const APP_KEY = 't2wd5v0je5rze4q';
const AUTHORIZE_URL = 'https://www.dropbox.com/1/oauth2/authorize'

export const shouldGetAccessToken = () => {
    if(localStorage.getItem(KEY)) {
        return false
    } else {
        return true
    }
}

export const authorize = () => {
    const redirect = process.env.NODE_ENV === 'production' 
        ? 'https://futurekind.github.io/elm-weighter/'
        : 'http://localhost:8000/'

    window.location.href = `${AUTHORIZE_URL}?response_type=token&client_id=${APP_KEY}&redirect_uri=${redirect}`
}

export const getAccessTokenInHashFragment = hashStr => {
    const fragments = hashStr.split('&').reduce((comp, fragment) => {
        const piece = fragment.split('=');
        return Object.assign({}, comp, {
            [piece[0]]:piece[1]
        });
    }, {});
    
    return fragments.access_token || false;
}

export const setAccessToken = token => {
    localStorage.setItem(KEY, token);
}

export const getAccessToken = () => localStorage.getItem(KEY);
