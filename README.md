# visit
The VisIt visualization program -- set up for the server side of a client-server configuration.

# Building the Docker container:

wget http://portal.nersc.gov/project/visit/releases/3.0.0/visit3_0_0.linux-x86_64-rhel7-wmesa.tar.gz
docker build . -t awesomeastro/visit
docker push awesomeastro/visit

# Building the Singularity container:

module load singularity
singularity build -F /cm/shared/apps/visit/3.0.0/visit-3.0.0.sif docker:awesomeastro/visit

# Set up visit wrapper script:

(edit bin/visit)

# Set up VisIt client side:

Edit host_symmetry.xml, changing "YOUR-USERNAME" to your username (on the server).
Copy into ~/.visit/hosts


