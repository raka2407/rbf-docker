#!/bin/bash

# No need for the overhead of Pabot if no parallelisation is required
if [ $ROBOT_THREADS -eq 1 ]
then
        robot \
        --outputDir /opt/robotframework/reports \
        ${ROBOT_OPTIONS} \
        /opt/robotframework/tests
else
        pabot \
        --verbose \
        --processes $ROBOT_THREADS \
        --outputDir /opt/robotframework/reports \
        ${ROBOT_OPTIONS} \
        /opt/robotframework/tests
fi
