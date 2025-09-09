import { Elm } from './Main.elm'
import './main.css'

const app = Elm.Main.init({
  node: document.getElementById('app'),
  flags: {
    width: window.innerWidth,
    seeds: [Math.random(), Math.random(), Math.random()]
  }
})