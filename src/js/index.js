import URL from 'urijs';
import { createFontLoader } from './lib/Fontloader';
import { Main } from '../elm/Main.elm';
import * as dropbox  from './lib/dropbox';
import * as api from './lib/api';

/**
 * Beispiel:
 * createFontLoader({
 *     'Some Fontname 1': {},
 *     'Some Fontname 2': {
 *         weight: ..., 
 *         style: ...,
 *         stretch: ...
 *     }
 * })
 */
const fontLoader = createFontLoader();
const url = new URL();
const hashFragment = url.fragment();
const accessTokenFromHash = dropbox.getAccessTokenInHashFragment(hashFragment)

if(accessTokenFromHash) {
    dropbox.setAccessToken(accessTokenFromHash)
    window.location.href = `${url.protocol()}://${url.host()}`
}

fontLoader.loadAll()
    .then(data => document.documentElement.className += ' fl')
    .catch(e => console.warn('Fonts could not be loaded', e))

const app = Main.embed(
    document.getElementById('root')
)

if(dropbox.shouldGetAccessToken()) {
    dropbox.authorize();
} else { 
    app.ports.loadData.subscribe(_ => {
        api.load()
            .then(data => {
                app.ports.dataFromServer.send(JSON.parse(data))
            })
    })

    app.ports.saveData.subscribe(data => {
        api.save(JSON.stringify(data))
    })
}

