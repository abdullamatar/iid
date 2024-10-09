// import { fs } from 'fs';
// import { path } from 'path';
// Function to read all markdown files from the 'posts' directory
function loadPosts() {
    // const postsDir = path.join(__dirname, "../", 'kalam');
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
console.log(loadPosts())

export const flags = ({ env }) => {
    console.log("I AM RUNNING")
    return {
        posts: {
            "temp": "Henlo"
        }
        // posts: loadPosts(),
    };
};

