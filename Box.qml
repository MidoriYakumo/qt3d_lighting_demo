import Qt3D.Core 2.0
import Qt3D.Extras 2.0

Entity {
	id: box

	CuboidMesh {
		id: cube
	}

	property Transform transform: Transform { }

	property PhongMaterial material: PhongMaterial { }

	components: [cube, transform, material]
}
