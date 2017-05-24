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

Main.embed(
    document.getElementById('root')
)
