import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.5

import QtQuick.Scene3D 2.0

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

ApplicationWindow {
	id: app
	visible: true
	width: 800
	height: 660
	title: qsTr("Materials")

	property color ambient: "gray"

	ColumnLayout {
		anchors.fill: parent
		anchors.margins: 8
		spacing: 8

		Scene3D {
			id: scene
			Layout.fillHeight: true
			Layout.fillWidth: true
			focus: true
			aspects: ["logic", "input"]

			Entity {
				id: root

				Camera {
					id: fpsCamera
					projectionType: CameraLens.PerspectiveProjection
					fieldOfView: 45  // Projection
					aspectRatio: scene.width/scene.height
					nearPlane : 0.1
					farPlane : 100.0
					position: Qt.vector3d(0,3,repeater.count/2.) // View
					viewCenter: Qt.vector3d(0,0,0)
					upVector: Qt.vector3d(0,1,0)
				}

				RenderSettings {
					id: renderSettings
					activeFrameGraph: ClearBuffers {
						buffers: ClearBuffers.ColorDepthBuffer
						clearColor: app.ambient
						RenderSurfaceSelector {
							CameraSelector {  // Camera installed
								camera: fpsCamera
							}
						}
					}
				}

				InputSettings {
					id: inputSettings
				}

				FirstPersonCameraController { camera: fpsCamera }

                SkyboxEntity {
                    id: skybox
                    cameraPosition: fpsCamera.position
                    baseName: "qrc:///skybox"
                    extension: ".jpg"
                }


                NodeInstantiator {
                    id: repeater
                    delegate: GlassBox {
                        transform.translation: Qt.vector3d(Math.cos(index*Math.PI/repeater.count*2.)*repeater.count/4.,
                                                           0,Math.sin(index*Math.PI/repeater.count*2.)*repeater.count/4.)
                        transform.rotationY: 45-index*180/repeater.count*2.
                        transform.rotationX: index*180/repeater.count*2.
                        transform.rotationZ: -index*180/repeater.count*2.
                        material.ambient:		Qt.rgba(modelData[1],	modelData[2],	modelData[3], 1.)
                        material.diffuse:		Qt.rgba(modelData[4],	modelData[5],	modelData[6], 1.)
                        material.specular :		Qt.rgba(modelData[7]*specSl.value,	modelData[8]*specSl.value,	modelData[9]*specSl.value, 1.)
                        material.shininess :	modelData[10] * shinSl.value
                        material.refractive: 1./1.3
                        material.transparency: Math.random()
                        material.skyboxTexture : skybox.skyboxTexture
                    }
                }

				NodeInstantiator {
					id: repeater2
					delegate: Box {
						transform.translation: Qt.vector3d(Math.cos(index*Math.PI/repeater2.count*2.)*repeater2.count/8.,
														   Math.sin(index*Math.PI/repeater2.count*2.)*repeater2.count/8., 0)
						transform.scale: .5
						transform.rotationY: 45-index*180/repeater2.count*2.
						transform.rotationX: index*180/repeater2.count*2.
						transform.rotationZ: -index*180/repeater2.count*2.
						material.ambient:		Qt.rgba(modelData[1],	modelData[2],	modelData[3], 1.)
						material.diffuse:		Qt.rgba(modelData[4],	modelData[5],	modelData[6], 1.)
						material.specular :		Qt.rgba(modelData[7]*specSl.value,	modelData[8]*specSl.value,	modelData[9]*specSl.value, 1.)
						material.shininess :	modelData[10] * shinSl.value
					}
				}

			}
		}

		Materials {
			id: materials

			Component.onCompleted: repeater.model = repeater2.model = list
		}

		RowLayout {
			Layout.fillWidth: true
			Text {
				text: "Specular:" + specSl.value.toFixed(2)
			}

			Slider {
				id: specSl
				Layout.fillWidth: true
				minimumValue: 1e-2
				maximumValue: 2e0
				value: 1.
			}
		}

		RowLayout {
			Layout.fillWidth: true
			Text {
				text: "Shininess:" + shinSl.value.toFixed(2)
			}

			Slider {
				id: shinSl
				Layout.fillWidth: true
				minimumValue: 1e-2
				maximumValue: 128
				value: 1.
			}
		}
	}
}
