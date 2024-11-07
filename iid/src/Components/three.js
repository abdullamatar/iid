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
            scene.background = new THREE.Color(0x6082B6)
            scene.fog = new THREE.Fog(0x036454F, 1, 5000)

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
            const tl = new THREE.TextureLoader();
            const texture = tl.load('./static/imgs/cubes.png');

            const whiteMaterial = new THREE.MeshBasicMaterial({ color: 0xfdd017, map: texture });

            const sphere = new THREE.Mesh(
                new THREE.SphereGeometry(100, 100, 100),
                whiteMaterial
            );
            sphere.position.set(-900, 300, -400);
            scene.add(sphere);

            // function loadSVGAsGeometry() {
            //     const loader = new SVGLoader();

            //     loader.load(
            //         './static/imgs/dallecubes.svg',
            //         function (data) {
            //             const paths = data.paths;
            //             const group = new THREE.Group();

            //             for (let i = 0; i < paths.length; i++) {
            //                 const path = paths[i];
            //                 const material = new THREE.MeshBasicMaterial({
            //                     color: path.color ? path.color : 0x546E7A,
            //                     side: THREE.DoubleSide,
            //                     depthWrite: false,
            //                     transparent: true
            //                 });

            //                 const shapes = SVGLoader.createShapes(path);

            //                 for (let j = 0; j < shapes.length; j++) {
            //                     const shape = shapes[j];
            //                     const geometry = new THREE.ShapeGeometry(shape);
            //                     const mesh = new THREE.Mesh(geometry, material);
            //                     group.add(mesh);
            //                 }
            //             }

            //             // Add the SVG group to the sphere or scene as needed
            //             mapSVGToSphere(group);

            //             // sphere.add(group);
            //         },
            //         undefined,
            //         function (error) {
            //             console.error('Error loading SVG with SVGLoader:', error);
            //         }
            //     );
            // }
            // loadSVGAsGeometry();

            // function mapSVGToSphere(group) {
            //     const sphereRadius = 100;

            //     // Position the group to align with the sphere
            //     group.position.set(-700, 150, -400);

            //     group.traverse(function (child) {
            //         if (child.isMesh) {
            //             const geometry = child.geometry;
            //             const positionAttribute = geometry.attributes.position;
            //             const vertex = new THREE.Vector3();

            //             for (let i = 0; i < positionAttribute.count; i++) {
            //                 vertex.fromBufferAttribute(positionAttribute, i);

            //                 // Normalize coordinates
            //                 const u = (vertex.x - geometry.boundingBox.min.x) / (geometry.boundingBox.max.x - geometry.boundingBox.min.x);
            //                 const v = (vertex.y - geometry.boundingBox.min.y) / (geometry.boundingBox.max.y - geometry.boundingBox.min.y);

            //                 // Convert to spherical coordinates
            //                 const theta = u * Math.PI * 2; // Longitude
            //                 const phi = v * Math.PI;       // Latitude

            //                 // Map onto sphere
            //                 const x = sphereRadius * Math.sin(phi) * Math.cos(theta);
            //                 const y = sphereRadius * Math.cos(phi);
            //                 const z = sphereRadius * Math.sin(phi) * Math.sin(theta);

            //                 // Adjust for sphere's position
            //                 positionAttribute.setXYZ(i, x - 700, y + 150, z - 400);
            //             }

            //             positionAttribute.needsUpdate = true;
            //             geometry.computeVertexNormals();
            //         }
            //     });
            // }

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

            const dirlight2 = new THREE.DirectionalLight(0xF57F17)
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
