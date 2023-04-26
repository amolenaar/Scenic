"""Scenic model for Mars rover scenarios in Webots."""

from scenic.simulators.webots.model import WebotsObject

# Set up workspace
width = 5
length = 5
workspace = Workspace(RectangularRegion(0 @ 0, 0, width, length))

# types of objects

class Goal(WebotsObject):
    """Flag indicating the goal location."""
    width: 0.3
    length: 0.3
    webotsType: 'GOAL'
    positionOffset: (0, 0, self.height/2)

class Rover(WebotsObject):
    """Mars rover."""
    width: 0.5
    length: 0.7
    height: 0.4
    webotsType: 'ROVER'
    orientationOffset: (90 deg, 0, 0)
    positionOffset: (0, 0, self.height/2)

class Debris(WebotsObject):
    """Abstract class for debris scattered randomly in the workspace."""
    position: new Point in workspace
    parentOrientation: Range(0, 360) deg
    positionOffset: Vector(0,0, -self.height/2)

class BigRock(Debris):
    """Large rock."""
    width: 0.17
    length: 0.17
    height: 0.17
    webotsType: 'ROCK_BIG'

class Rock(Debris):
    """Small rock."""
    width: 0.10
    length: 0.10
    height: 0.10
    webotsType: 'ROCK_SMALL'

class Pipe(Debris):
    """Pipe with variable length."""
    width: 0.2
    length: Range(0.5, 1.5)
    height: self.width
    webotsType: 'PIPE'

    def startDynamicSimulation(self):
        # Apply variable length
        self.webotsObject.getField('height').setSFFloat(self.length)
        # Apply 3D rotation to make pipes lie flat on surface
        rotation = [cos(self.heading), sin(self.heading), 0, 90 deg]
        self.webotsObject.getField('rotation').setSFRotation(rotation)
