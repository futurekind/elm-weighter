import { createFontLoader } from './lib/Fontloader';
import { Main } from '../elm/Main.elm';

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

fontLoader.loadAll()
    .then(data => document.documentElement.className += ' fl')
    .catch(e => console.warn('Fonts could not be loaded', e))

const app = Main.embed(
    document.getElementById('root')
)

const dummyApi = () => new Promise(res => {
    setTimeout(() => {
        res([
            { value: 99.8, date: '2017-06-02', title: ''},
            { value: 100.8, date: '2017-05-15', title: ''},
            { value: 99.1, date: '2017-05-01', title: ''},
        ])
    }, 1000)
})

app.ports.loadData.subscribe(_ => {
    dummyApi()
        .then(data => {
            app.ports.dataFromServer.send(data)
        })
})
