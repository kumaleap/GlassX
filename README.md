# GlassX 🌟

> 跨平台毛玻璃效果展示项目 - 一键体验五大平台的原生毛玻璃视觉效果

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platforms](https://img.shields.io/badge/platforms-H5%20%7C%20iOS%20%7C%20Android%20%7C%20HarmonyOS%20%7C%20WeChat-brightgreen.svg)
![Version](https://img.shields.io/badge/version-1.0.0-orange.svg)

## 📖 项目简介

GlassX 是一个跨平台毛玻璃效果展示项目，提供了在不同平台上实现高质量毛玻璃（Frosted Glass）视觉效果的完整解决方案。项目包含 **H5、iOS、Android、HarmonyOS、微信小程序** 五个平台的原生实现，每个平台都采用对应的最佳技术方案。

## ✨ 核心特性

### 🎨 视觉效果
- **真实毛玻璃效果**: 使用各平台原生毛玻璃技术
- **实时参数调节**: 三个核心参数实时响应
- **多层渲染系统**: 六层效果叠加，视觉层次丰富
- **流畅动画效果**: 所有参数变化都有平滑过渡

### 🔧 交互功能
- **可拖拽面板**: 毛玻璃面板支持自由拖拽
- **参数实时调节**: 
  - **Blur Value (0-50)**: 控制模糊强度
  - **Refraction (0.10-0.25)**: 控制折射效果
  - **Depth (4-16)**: 控制景深层次
- **边界限制**: 智能边界检测，确保面板不超出屏幕

### 🌐 跨平台支持
- **H5 (Vue3)**: 现代浏览器支持
- **iOS (SwiftUI)**: 原生iOS体验  
- **Android (Jetpack Compose)**: Material Design 3
- **HarmonyOS (ArkTS)**: 鸿蒙原生开发
- **微信小程序**: 原生小程序技术

## 🛠 技术栈

### H5版本
```json
{
  "framework": "Vue 3 + TypeScript",
  "bundler": "Vite",
  "styling": "CSS3 + backdrop-filter",
  "features": ["Composition API", "Responsive Design"]
}
```

### iOS版本
```swift
{
  "framework": "SwiftUI",
  "language": "Swift",
  "blur": "UIVisualEffectView + Material",
  "features": ["六层叠加系统", "动态材质切换"]
}
```

### Android版本
```kotlin
{
  "framework": "Jetpack Compose",
  "language": "Kotlin", 
  "blur": "真实高斯模糊 + 渐变叠加",
  "features": ["Glide变换", "Material Design 3"]
}
```

### HarmonyOS版本
```typescript
{
  "framework": "ArkTS",
  "language": "TypeScript",
  "blur": "backdropBlur原生效果",
  "features": ["响应式状态管理", "手势交互"]
}
```

### 微信小程序版本
```javascript
{
  "framework": "原生小程序",
  "language": "TypeScript",
  "components": ["movable-view", "slider"],
  "features": ["原生组件", "白色主题"]
}
```

## 🚀 快速开始

### 前置要求

- **H5**: Node.js 16+ 
- **iOS**: Xcode 15+, iOS 18.5+
- **Android**: Android Studio, Gradle 7.5+
- **HarmonyOS**: DevEco Studio 4.0+
- **微信小程序**: 微信开发者工具

### 安装运行

#### H5版本
```bash
cd glassx_h5
npm install
npm run dev
# 访问 http://localhost:3001
```

#### iOS版本  
```bash
cd glassx_ios
open glassx_ios.xcodeproj
# 在Xcode中选择iPhone模拟器运行
```

#### Android版本
```bash
cd glassx_android
./gradlew assembleDebug
# 或在Android Studio中打开项目运行
```

#### HarmonyOS版本
```bash
cd glassx_harmoyos
# 在DevEco Studio中打开项目
# 选择预览器或模拟器运行
```

#### 微信小程序版本
```bash
cd glassx-mini-wechat
# 在微信开发者工具中导入项目
# 选择编译并预览
```

## 📁 项目结构

```
GlassX/
├── glassx_h5/                 # Vue3 H5版本
│   ├── src/
│   │   ├── views/
│   │   │   └── GlassEffectView.vue
│   │   └── assets/
│   │       └── bg.png         # 16.8MB背景图
│   └── package.json
├── glassx_ios/                # SwiftUI iOS版本
│   ├── glassx_ios/
│   │   ├── ContentView.swift  # 主界面
│   │   └── Assets.xcassets/
│   │       └── bg.imageset/   # 背景图资源
│   └── glassx_ios.xcodeproj
├── glassx_android/            # Jetpack Compose Android版本
│   ├── app/src/main/
│   │   ├── java/.../MainActivity.kt
│   │   └── res/drawable/
│   │       └── bg.png         # 背景图资源
│   └── build.gradle.kts
├── glassx_harmoyos/           # ArkTS HarmonyOS版本
│   ├── entry/src/main/
│   │   ├── ets/pages/
│   │   │   └── Index.ets      # 主页面
│   │   └── resources/base/media/
│   │       └── bg.png         # 背景图资源
│   └── build-profile.json5
└── glassx-mini-wechat/        # 微信小程序版本
    ├── miniprogram/
    │   ├── pages/index/
    │   │   ├── index.ts       # 主页面逻辑
    │   │   ├── index.wxml     # 页面结构
    │   │   └── index.less     # 页面样式
    │   └── images/
    │       └── bg.png         # 背景图资源
    └── project.config.json
```

## 🎛 参数说明

| 参数 | 范围 | 说明 | 效果 |
|------|------|------|------|
| **Blur Value** | 0-50 | 模糊强度 | 控制毛玻璃的模糊程度，0为完全透明，50为最强模糊 |
| **Refraction** | 0.10-0.25 | 折射强度 | 控制光线折射效果和高光强度 |
| **Depth** | 4-16 | 景深层次 | 控制阴影深度和边框厚度，创造立体感 |

## 🌟 平台特色功能

### iOS版本特色
- **六层叠加系统**: UIKit blur + SwiftUI材质 + 多层渐变
- **动态材质切换**: 根据blur值自动切换5种不同材质
- **智能透明度**: blur=0时接近透明，blur=50时效果饱满

### Android版本特色  
- **真实高斯模糊**: 使用Glide BlurTransformation
- **内存优化**: 图片压缩和缓存机制
- **Material Design 3**: 现代化的设计语言

### HarmonyOS版本特色
- **原生backdropBlur**: 鸿蒙系统级毛玻璃效果
- **ArkTS响应式**: 状态变化自动更新UI
- **手势优化**: 专门优化的拖拽交互

### 微信小程序特色
- **movable-view**: 原生可拖拽组件
- **白色主题**: 统一的视觉风格
- **性能优化**: 小程序环境下的最佳实践

## 🔧 技术亮点

### 跨平台一致性
- 所有平台功能和参数范围完全一致
- 统一的交互逻辑和视觉效果
- 相同的背景图和设计语言

### 原生技术采用
- **iOS**: UIVisualEffectView + SwiftUI Material
- **Android**: Glide BlurTransformation + Compose
- **HarmonyOS**: 系统级backdropBlur API
- **H5**: CSS backdrop-filter
- **小程序**: 原生组件优化

### 性能优化
- 图片压缩和缓存策略
- 内存使用优化
- 流畅的60fps动画效果
- 智能渲染机制

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

## 📝 更新日志

### v1.0.0 (2024-06-27)
- ✅ 完成五大平台毛玻璃效果实现
- ✅ 统一的参数系统和交互逻辑
- ✅ 优化iOS六层叠加效果
- ✅ 修复Android内存和兼容性问题
- ✅ 完善HarmonyOS手势交互
- ✅ 优化微信小程序性能

## 📜 开源协议

本项目采用 [MIT License](LICENSE) 开源协议。

## 👨‍💻 作者

- **KumaLeap** - 项目创建者和主要维护者

## 🙏 致谢

感谢以下开源项目和技术社区：
- Vue.js Team
- SwiftUI Team  
- Jetpack Compose Team
- HarmonyOS Team
- 微信小程序团队

---

⭐ 如果这个项目对你有帮助，请给它一个星标！ 