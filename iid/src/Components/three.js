// taken from https://elm.land/guide/working-with-js.html
import * as THREE from 'three'
import { OrbitControls } from 'three/addons/controls/OrbitControls.js'
import { SVGLoader } from 'three/examples/jsm/loaders/SVGLoader.js';


window.customElements.define("forest-demo", class extends HTMLElement {
    connectedCallback() {
        let size = {
            width: window.innerWidth,
            height: window.innerHeight
        }

        let camera, controls, scene, renderer
        let self = this
        init()
        animate()
        function init() {
            scene = new THREE.Scene()
            scene.background = new THREE.Color(0x000000)
            scene.fog = new THREE.Fog(0xFFFFFF, 1, 5000)

            renderer = new THREE.WebGLRenderer({ antialias: true })

            renderer.setPixelRatio(window.devicePixelRatio)
            renderer.setSize(size.width, size.height)

            self.appendChild(renderer.domElement)

            camera = new THREE.PerspectiveCamera(70, size.width / size.height, 1, 1000)
            camera.position.set(200, 44, 0)

            // ctrls
            controls = new OrbitControls(camera, renderer.domElement)
            controls.listenToKeyEvents(window)
            controls.enableDamping = true
            controls.dampingFactor = 0.25
            controls.screenSpacePanning
            controls.minDistance = 100
            controls.maxDistance = 500
            controls.maxPolarAngle = Math.PI / 2


            // Create a white sphere with a placeholder material
            const whiteMaterial = new THREE.MeshBasicMaterial({ color: 0xffffff });
            const sphere = new THREE.Mesh(
                new THREE.SphereGeometry(100, 100, 100),
                whiteMaterial
            );
            sphere.position.set(-700, 150, -400);
            scene.add(sphere);

            // Load the SVG and create a texture
            const loader = new SVGLoader();
            loader.load(
                '../../static/imgs/dallecubes.svg',
                function (data) {
                    const paths = data.paths;
                    const canvas = document.createElement('canvas');
                    const context = canvas.getContext('2d');

                    // Set canvas size
                    canvas.width = 1024;
                    canvas.height = 1024;

                    // Draw SVG paths onto the canvas
                    paths.forEach((path) => {
                        const fillColor = path.userData.style.fill;
                        if (fillColor !== undefined && fillColor !== 'none') {
                            context.fillStyle = fillColor;
                            const shapes = SVGLoader.createShapes(path);
                            shapes.forEach((shape) => {
                                const shapePath = shape.getPoints();
                                context.beginPath();
                                context.moveTo(shapePath[0].x, shapePath[0].y);
                                for (let i = 1; i < shapePath.length; i++) {
                                    context.lineTo(shapePath[i].x, shapePath[i].y);
                                }
                                context.closePath();
                                context.fill();
                            });
                        }
                    });

                    // Create a texture from the canvas
                    const texture = new THREE.CanvasTexture(canvas);
                    sphere.material.map = texture;
                    sphere.material.needsUpdate = true;
                },
                undefined,
                function (err) {
                    console.error('An error occurred loading the SVG', err);
                }
            );


            //world
            const geometry = new THREE.CylinderGeometry(0, 10, 30, 4, 1)
            const material = new THREE.MeshLambertMaterial({ color: 0xffffff, flatShading: true })

            for (let i = 0; i < 400; i++) {
                const mesh = new THREE.Mesh(geometry, material)
                mesh.position.x = Math.random() * 1600 - 800
                mesh.position.y = 0
                mesh.position.z = Math.random() * 1600 - 800
                mesh.updateMatrix()
                mesh.matrixAutoUpdate = false
                scene.add(mesh)
            }


            //light
            const dirlight1 = new THREE.DirectionalLight(0xffffff)
            dirlight1.position.set(1, 1, 1)
            scene.add(dirlight1)

            const dirlight2 = new THREE.DirectionalLight(0xffaa00)
            dirlight2.position.set(-1, -1, -1)
            scene.add(dirlight2)

            const ambientLight = new THREE.AmbientLight(0x222222)
            scene.add(ambientLight)

            window.addEventListener('resize', onWindowResize, false)


        }

        function onWindowResize() {
            camera.aspect = size.width / size.height
            camera.updateProjectionMatrix()
            renderer.setSize(size.width, size.height)
        }

        function animate() {
            requestAnimationFrame(animate) // render loop
            controls.update()
            render()
        }

        function render() {
            renderer.render(scene, camera)
        }
    }

})
