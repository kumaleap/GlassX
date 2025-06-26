# GlassX H5

基于 Vue3 + TypeScript 的移动端 H5 应用框架

## ✨ 特性

- 🚀 **Vue 3** - 使用最新的 Vue 3 组合式 API
- 🔧 **TypeScript** - 类型安全的 JavaScript 超集
- 📱 **移动端优先** - 专为移动设备优化的响应式设计
- ⚡ **Vite** - 快速的构建工具和开发服务器
- 🛣️ **Vue Router** - 官方路由管理器
- 🗃️ **Pinia** - 轻量级状态管理
- 🎨 **现代 UI** - 毛玻璃效果和渐变设计
- 📏 **代码规范** - 集成 ESLint 和 Prettier
- 🧪 **测试** - Vitest 单元测试 + Playwright E2E 测试

## 📦 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue 3 | 3.5.17 | JavaScript 框架 |
| TypeScript | 5.8.0 | 类型安全 |
| Vite | 7.0.0 | 构建工具 |
| Vue Router | 4.5.1 | 路由管理 |
| Pinia | 3.0.3 | 状态管理 |

## 🚀 快速开始

### 安装依赖

```bash
npm install
```

### 开发模式

```bash
npm run dev
```

项目将在 http://localhost:3000 启动

### 构建生产版本

```bash
npm run build
```

### 预览生产版本

```bash
npm run preview
```

## 📱 移动端优化

### 视口配置
- 禁用缩放，固定视口尺寸
- 支持安全区域适配 (iPhone X 及以上)
- 防止意外的电话号码识别

### 样式优化
- 移动端优先的响应式设计
- 支持 CSS 安全区域 (safe-area-inset)
- 触摸友好的交互元素
- 防止横向滚动

### 性能优化
- 代码分割和懒加载
- 资源压缩和优化
- 服务端渲染友好

## 🛠️ 开发命令

```bash
# 开发服务器
npm run dev

# 类型检查
npm run type-check

# 构建项目
npm run build

# 构建并预览
npm run preview

# 代码检查
npm run lint

# 代码格式化
npm run format

# 单元测试
npm run test:unit

# E2E 测试
npm run test:e2e
```

## 📁 项目结构

```
glassx_h5/
├── public/                 # 静态资源
│   ├── assets/            # 样式和资源文件
│   ├── components/        # 通用组件
│   ├── router/           # 路由配置
│   ├── stores/           # Pinia 状态管理
│   ├── views/            # 页面组件
│   ├── App.vue           # 根组件
│   └── main.ts           # 入口文件
├── index.html            # HTML 模板
├── vite.config.ts        # Vite 配置
├── tsconfig.json         # TypeScript 配置
└── package.json          # 项目配置
```

## 🎨 设计规范

### 色彩
- 主色调：渐变蓝紫色 (#667eea → #764ba2)
- 强调色：橙红色渐变 (#ff6b6b → #ee5a24)
- 文字：白色系列

### 交互
- 毛玻璃效果 (backdrop-filter: blur)
- 悬停动画 (transform 和 box-shadow)
- 圆角设计 (border-radius)

### 响应式断点
- 移动端：< 768px
- 平板：768px - 1024px  
- 桌面：> 1024px

## 🔧 配置说明

### Vite 配置特点
- 支持移动端开发 (host: 0.0.0.0)
- 自动代码分割
- TypeScript 支持
- 路径别名 (@/ 指向 src/)

### 移动端 Meta 标签
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-capable" content="yes">
```

## 🤝 贡献

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

MIT License

## 🙏 致谢

感谢以下开源项目：
- [Vue.js](https://vuejs.org/)
- [Vite](https://vitejs.dev/)
- [TypeScript](https://www.typescriptlang.org/)
- [Vue Router](https://router.vuejs.org/)
- [Pinia](https://pinia.vuejs.org/)
