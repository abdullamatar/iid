// import { nodePolyfills } from "vite-plugin-node-polyfills";
// import fs from 'node:fs';
// import path from 'node:path';
// import * as THREE from 'three'
console.log(import.meta.env)

// import * as fs from 'fs';
// import * as path from 'path';
// const fs = require('fs');
// import { defineConfig } from "vite";

// export default defineConfig({
//     plugins: [nodePolyfills()],
// });

// Function to read all markdown files from the 'posts' directory

function loadPosts() {
    // const postsDir = "../" + "kalam";
    // const postsDir = path.join(__dirname, "../", "kalam");

    // const files = fs.readdirSync(postsDir);
    // const posts = {};

    // files.forEach((file) => {
    //     if (path.extname(file) === '.md') {
    //         const postId = path.basename(file, '.md');
    //         const content = fs.readFileSync(path.join(postsDir, file), 'utf8');
    //         posts[postId] = content;
    //     }
    // });

    // return posts;
}
loadPosts()

export const flags = ({ env }) => {
    console.log("I AM RUNNING")
    return {
        posts: {
            "temp": "Henlo"
        }
        // posts: loadPosts(),
    };
};

