(function () {
  const state = {
    board: null,
    scene: null,
  }

  function postMessage(payload) {
    if (window.GeometryBridge && window.GeometryBridge.postMessage) {
      window.GeometryBridge.postMessage(JSON.stringify(payload))
    }
  }

  function clearNode(node) {
    while (node.firstChild) {
      node.removeChild(node.firstChild)
    }
  }

  function renderFallback(scene) {
    const host = document.getElementById('jxgbox')
    if (!host) return
    clearNode(host)

    const wrapper = document.createElement('div')
    wrapper.style.padding = '16px'
    wrapper.style.color = '#1f2d3d'
    wrapper.style.fontFamily = 'sans-serif'
    wrapper.innerText =
      'JXG engine is unavailable. Showing simplified preview.\n' +
      `elements: ${scene.elements.length}`
    host.appendChild(wrapper)
  }

  function createMap(elements) {
    const map = {}
    elements.forEach((e) => {
      map[e.id] = e
    })
    return map
  }

  function renderWithJsxGraph(scene) {
    const host = document.getElementById('jxgbox')
    clearNode(host)

    state.board = JXG.JSXGraph.initBoard('jxgbox', {
      boundingbox: [scene.viewport.xMin, scene.viewport.yMax, scene.viewport.xMax, scene.viewport.yMin],
      axis: true,
      showCopyright: false,
      showNavigation: false,
    })

    const refs = {}
    const pendingDynamic = []
    const elementsById = createMap(scene.elements)

    scene.elements.forEach((element) => {
      try {
        if (element.type === 'point') {
          refs[element.id] = state.board.create('point', element.pos || [0, 0], {
            name: element.label || element.id,
            fixed: false,
          })
        } else if (element.type === 'line') {
          const p1 = refs[element.p1] || null
          const p2 = refs[element.p2] || null
          if (p1 && p2) {
            refs[element.id] = state.board.create('line', [p1, p2], {
              strokeColor: '#3d7bfd',
              straightFirst: true,
              straightLast: true,
            })
          }
        } else if (element.type === 'circle') {
          const center = element.center || [0, 0]
          const radius = element.radius || 1
          refs[element.id] = state.board.create('circle', [center, radius], {
            strokeColor: '#1f78b4',
            dash: element.style === 'dashed' ? 2 : 0,
          })
        } else if (element.type === 'dynamic_point') {
          pendingDynamic.push(element)
        }
      } catch (err) {
        postMessage({ type: 'error', message: String(err) })
      }
    })

    pendingDynamic.forEach((element) => {
      const target = refs[element.targetId]
      const source = elementsById[element.targetId]

      if (!target) return

      if (source && source.type === 'circle') {
        const t = typeof element.initialT === 'number' ? element.initialT : 0.25
        const center = source.center || [0, 0]
        const r = source.radius || 1
        const x = center[0] + r * Math.cos(t * Math.PI * 2)
        const y = center[1] + r * Math.sin(t * Math.PI * 2)
        const point = state.board.create('glider', [x, y, target], {
          name: element.label || element.id,
          size: 4,
          fillColor: '#ff7043',
          strokeColor: '#ff7043',
        })

        point.on('drag', function () {
          postMessage({
            type: 'pointMoved',
            id: element.id,
            x: point.X(),
            y: point.Y(),
          })
        })

        refs[element.id] = point
      }
    })
  }

  window.renderScene = function (scene) {
    try {
      state.scene = scene
      if (window.JXG && window.JXG.JSXGraph) {
        renderWithJsxGraph(scene)
      } else {
        renderFallback(scene)
        postMessage({
          type: 'error',
          message: 'JXG.JSXGraph is not loaded. Add jsxgraphcore.js for full rendering.',
        })
      }
    } catch (e) {
      postMessage({ type: 'error', message: String(e) })
    }
  }

  postMessage({ type: 'renderReady' })
})()
