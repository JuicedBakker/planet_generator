import peasy.*;
PVector[][] planet;
int total = 400;
float maxAmp = 0.8;
float phase = 0;
float angle = 0;
PeasyCam cam;

void setup() {
    size(displayWidth, displayHeight, P3D);
    planet = new PVector[total+1][total+1];
    cam = new PeasyCam(this, 800);
    cam.setActive(false);
}

void draw() {
    directionalLight(126, 126, 126, 1, 0, -1);
    ambientLight(102, 102, 102);
    background(0);
    drawPlanet();
}
void keyPressed() {
    clear(); // Clear the canvas
    phase += 30; // Increment the phase to generate new terrain
    drawPlanet();
}

void drawPlanet() {
    noStroke();
    
    // Make the sphere spin along its Y axis
    rotateY(angle);
    angle += 0.02;
    
    // Create the sphere that forms the water.
    fill(79,76,176);
    sphere(150); 
    
    for (int i = 0; i < total+1; i++) {
        float lat = map(i, 0, total, 0, PI);

        beginShape(TRIANGLE_STRIP);
        for (int j = 0; j < total+1; j++) {
            float lon = map(j, 0, total, 0, 2*PI);
            
            // Generate an offset by inserting the x/y/z coordinate into a new range.
            float xoff = map(sin(lat) * cos(lon), -1, 1, 6, maxAmp);
            float yoff = map(sin(lat) * sin(lon), -1, 1, 6, maxAmp);
            float zoff = map(cos(lat), -1, 1, 6, maxAmp);
            
            //Generate perlin noise using the x/y/z offsets and the current phase.
            float pNoise = noise(xoff+phase, yoff+phase, zoff+phase);
            float r = map(pNoise, 0, 1, 100, 200);

            // Converting the latitude and longitude to x/y/z coordinates
            float x = r * sin(lat) * cos(lon);
            float y = r * sin(lat) * sin(lon);
            float z = r * cos(lat);
            
            // Add the vector to the 2d array.
            planet[i][j] = new PVector(x, y, z);

            if (i!=0) 
            {
                PVector v1 = planet[i-1][j];
                PVector v2 = planet[i][j];
                
                // Calculate the length of a vertex.
                float vertexLength = sqrt(v2.x * v2.x + v2.y * v2.y + v2.z * v2.z);
                
                if (vertexLength > 170)
                {
                    // Determine color of verteces at snow height
                    fill(233,239,249);
                }
                else if (vertexLength > 164)
                {
                    // Determine color of verteces at stone height
                    fill(128, 128, 128);
                }
                else if (vertexLength > 157)
                {
                    // Determine color of verteces at dirt height
                    fill(120, 104, 78);
                }
                else if (vertexLength > 151)
                {
                    // Determine color of verteces at grass height
                    fill(86,125,70);
                }
                else if (vertexLength > 140) {
                   // Anything around water level will become sand colored
                   fill(216,197,150); 
                }
                else
                {
                    // Hide verteces below water level for better performance
                    fill(0);
                }
                // Output verteces
                vertex(v1.x, v1.y, v1.z);
                vertex(v2.x, v2.y, v2.z);
            }
        }
        endShape(CLOSE);
    }
}
