# Plan

## 功能

### 拍照解题

#### 1. 拍照

需要调用摄像头

扫描：

1. 匡正图像
2. 调整背景，去除阴影
3. 统一颜色为 黑红

#### 2. 识别文字

要求

1. 可兼容手写
2. 公式识别准确

问题：

1. 如果有图像怎么识别

#### 3. 判断能否可视化（题目类型）

步骤

1. 加特定提示词

问题

1. 有哪些类型可以可视化
2. 怎么处理多类型融合的题目

#### 4. 解题

步骤

1. 加特定提示词
2. 可视化代码（如果有）

问题：

1. 可视化使用哪种类型

- 内嵌一个python从而渲染动画或视频（不确定能否实现 或实现效果如何）
- 内嵌浏览器渲染

#### 5. 展示结果

目标：

1. 将ai返回内容处理为markdown格式（可通过提示词完成）
2. 展示md内容，并可选复制为纯文本/markdown
3. 过程中的公式可单独复制为latex公式
4. 动画渲染 可交互

#### 6. 加入错题库

步骤：

1. 大模型整理标签化（需要提前确定好有哪些标签，在里面选择）
2. 标签形成双向链接

待定：

1. 该错题库应当和知识库是相通的，或者说类似二分图的形式
2. 错题库也可以通过直接扫描已经经过修改的错题添加（实现形式有待商榷）

## 关于可视化的解决方案

### 🏗️ 第一阶段：定义“几何语言” (JSON Protocol)

不要让 AI 写代码，要让它写**描述**。我们需要定义一套 LLM 易于理解的 JSON 协议。

JSON

```
{
  "viewport": {"xMin": -5, "xMax": 5, "yMin": -5, "yMax": 5},
  "elements": [
    {
      "id": "A", "type": "point", "pos": [-2, 0], "label": "A", "visible": true
    },
    {
      "id": "circle_O", "type": "circle", "center": [0, 0], "radius": 2, "style": "dashed"
    },
    {
      "id": "P", 
      "type": "dynamic_point", 
      "constraint": "on_entity", 
      "targetId": "circle_O",
      "initialT": 0.5, 
      "label": "P"
    }
  ]
}
```

---

### 🧠 第二阶段：提示词工程 (System Prompt)

在调用你的火山引擎（Volcengine）接口时，注入以下系统指令，强制 AI 扮演“几何翻译官”。

> **System Prompt:**
> 
> 你是一个几何专家。用户会提供一道数学题。
> 
> 1. 解析题目中的几何实体：点、线、圆、轨迹。
>     
> 2. 识别**动点**及其约束（例如：点 P 在圆 O 上）。
>     
> 3. 输出我定义的 `GeometryJSON` 格式，严禁输出任何自然语言解释。
>     
> 4. 自动计算合适的 `viewport`（视口范围），确保图形在手机屏幕中央。
>     

---

### 🛠️ 第三阶段：Flutter 端核心实现 (The "Engine")

你需要三个核心组件来解析并渲染这个 JSON。

#### 1. 数据模型 (Models)

定义 Dart 类来承载 JSON 数据。

Dart

```
abstract class GeoElement {
  final String id;
  GeoElement(this.id);
}

class GeoPoint extends GeoElement {
  Offset pos;
  GeoPoint(super.id, this.pos);
}

class DynamicPoint extends GeoPoint {
  final String targetId; // 约束目标的 ID
  double t; // 0.0 到 1.0 的参数化位置
  DynamicPoint(super.id, super.pos, this.targetId, this.t);
}
```

#### 2. 约束求解器 (Constraint Solver)

这是实现交互的关键。当用户拖动点 $P$ 时，我们需要计算它在约束目标（如圆）上的最近点。

Dart

```
Offset solveConstraint(Offset touchPos, GeoElement target) {
  if (target is GeoCircle) {
    // 强制点在圆周上：圆心 + 半径 * 单位向量
    final direction = (touchPos - target.center);
    return target.center + (direction / direction.distance) * target.radius;
  }
  // 其他几何约束逻辑...
  return touchPos;
}
```

#### 3. 动态画笔 (Interactive Painter)

使用 `CustomPainter` 渲染，并配合 `GestureDetector`。

Dart

```
// 在 BeautifulResultPage 的面板中插入
GestureDetector(
  onPanUpdate: (details) {
    // 1. 找到距离触摸点最近的动点
    // 2. 调用 solveConstraint 更新动点坐标
    // 3. setState() 触发重绘
  },
  child: CustomPaint(
    painter: GeometryPainter(sceneData),
    size: Size(double.infinity, 300),
  ),
)
```

---

### 🎨 第四阶段：UI/UX 优化 (高级感提升)

既然你追求优美的动画，可以加入以下细节：

1. **流式渲染 (Streaming UI)**：由于 AI 生成 JSON 有延迟，你可以先渲染坐标轴。当 `elements` 数组中出现一个新 ID 时，用一个 **Fade-in** 动画把图形画出来。
    
2. **吸附动效**：当动点移动到特殊位置（如 $x$ 轴交点、顶点）时，手机触发轻微的 **Haptic Feedback**（震动反馈）。
    
3. **实时数值标注**：在动点旁边实时显示 LaTeX 坐标，例如使用 `Math.tex` 渲染 `(cos θ, sin θ)`。

### 🚀 针对你（南开 AI 学子）的开发路线图

1. **MVP 阶段 (Minimum Viable Product)**：
    
    - 手动写死一个 JSON。
        
    - 实现 `CustomPainter` 渲染静态的点和线。
        
2. **交互阶段**：
    
    - 实现 `GestureDetector`，让点能被拖动。
        
    - 加入简单的“圆上动点”数学逻辑。
        
3. **AI 集成阶段**：
    
    - 将火山引擎的流式输出接入。
        
    - 编写 JSON 校验逻辑，防止 AI 格式错误导致闪退。