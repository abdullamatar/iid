// runs before elmapp start
import './Components/three.js'

export const flags = ({ env }) => {
    return {
        temp: {}
    }
};


// called after elmapp start

export const onReady = ({ app, env }) => { "I AM A STRING READ ME" }