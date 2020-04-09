import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    width: window.innerWidth,
    seeds: [Math.random(), Math.random(), Math.random()]
  }
});