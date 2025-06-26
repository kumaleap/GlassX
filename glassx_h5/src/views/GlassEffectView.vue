<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'

// 玻璃效果参数
const blurValue = ref(21)
const refraction = ref(0.15)
const depth = ref(8)

// 玻璃块位置和拖拽状态
const glassPosition = ref({ x: 100, y: 100 })
const isDragging = ref(false)
const dragOffset = ref({ x: 0, y: 0 })

// 计算玻璃效果样式 - 优化参数影响
const glassStyle = computed(() => {
  // 限制深度影响范围，减少白色渲染
  const normalizedDepth = Math.max(2, Math.min(depth.value, 16))
  const innerGlowIntensity = Math.max(0.2, Math.min(0.5, 0.2 + (normalizedDepth - 2) * 0.02))
  
  return {
    background: `rgba(255, 255, 255, ${refraction.value})`,
    backdropFilter: `blur(${blurValue.value}px)`,
    WebkitBackdropFilter: `blur(${blurValue.value}px)`,
    borderRadius: '20px',
    border: `1px solid rgba(255, 255, 255, 0.3)`,
    boxShadow: `
      0 ${normalizedDepth}px ${normalizedDepth * 2}px rgba(0, 0, 0, 0.1),
      inset 0 1px 0 rgba(255, 255, 255, 0.5),
      inset 0 -1px 0 rgba(255, 255, 255, 0.1),
      inset 0 0 ${8 + normalizedDepth}px ${4 + normalizedDepth * 0.5}px rgba(255, 255, 255, ${innerGlowIntensity})
    `,
    transform: `translate(${glassPosition.value.x}px, ${glassPosition.value.y}px)`
  }
})

// 拖拽事件处理
const startDrag = (event: MouseEvent | TouchEvent) => {
  // 防止在滑块上开始拖拽
  const target = event.target as HTMLElement
  if (target.closest('.control-item') || target.closest('.slider-container')) {
    return
  }
  
  isDragging.value = true
  const clientX = 'touches' in event ? event.touches[0].clientX : event.clientX
  const clientY = 'touches' in event ? event.touches[0].clientY : event.clientY
  
  dragOffset.value = {
    x: clientX - glassPosition.value.x,
    y: clientY - glassPosition.value.y
  }
  
  // 防止页面滚动和选择文本
  event.preventDefault()
  
  document.addEventListener('mousemove', onDrag, { passive: false })
  document.addEventListener('mouseup', endDrag)
  document.addEventListener('touchmove', onDrag, { passive: false })
  document.addEventListener('touchend', endDrag)
}

const onDrag = (event: MouseEvent | TouchEvent) => {
  if (!isDragging.value) return
  
  // 检查是否在滑块区域内拖拽，如果是则不阻止默认行为
  const target = event.target as HTMLElement
  if (!target.closest('.slider-container')) {
    // 只有在非滑块区域才防止页面滚动
    event.preventDefault()
  }
  
  const clientX = 'touches' in event ? event.touches[0].clientX : event.clientX
  const clientY = 'touches' in event ? event.touches[0].clientY : event.clientY
  
  const newX = clientX - dragOffset.value.x
  const newY = clientY - dragOffset.value.y
  
  // 限制在视窗范围内
  const maxX = window.innerWidth - 320
  const maxY = window.innerHeight - 400
  
  glassPosition.value = {
    x: Math.max(0, Math.min(newX, maxX)),
    y: Math.max(0, Math.min(newY, maxY))
  }
}

const endDrag = () => {
  isDragging.value = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', onDrag)
  document.removeEventListener('touchend', endDrag)
}

// 生命周期
onMounted(() => {
  // 初始化位置到屏幕中央
  glassPosition.value = {
    x: Math.max(0, (window.innerWidth - 320) / 2),
    y: Math.max(0, (window.innerHeight - 400) / 2)
  }
})

onUnmounted(() => {
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', onDrag)
  document.removeEventListener('touchend', endDrag)
})
</script>

<template>
  <div class="glass-effect-page">
    <!-- 背景层 -->
    <div class="background">
      <div class="background-image"></div>
      <div class="background-overlay"></div>
    </div>

    <!-- 可拖拽的玻璃设置面板 -->
    <div
      class="glass-panel"
      :style="glassStyle"
      @mousedown="startDrag"
      @touchstart="startDrag"
    >

      <!-- 拖拽手柄 -->
      <div class="drag-handle">
        <div class="handle-indicator"></div>
      </div>

      <!-- 设置标题 -->
      <div class="panel-header">
        <h2 class="panel-title">Settings</h2>
      </div>

      <!-- 控制项 -->
      <div class="controls">
        <!-- Blur value -->
        <div class="control-item">
          <div class="control-header">
            <span class="control-label">Blur value</span>
            <span class="control-value">{{ blurValue }}</span>
          </div>
          <div class="slider-container" @mousedown.stop @touchstart.stop>
            <input
              v-model.number="blurValue"
              type="range"
              min="0"
              max="50"
              step="1"
              class="native-slider"
            />
          </div>
        </div>

        <!-- Refraction -->
        <div class="control-item">
          <div class="control-header">
            <span class="control-label">Refraction 折射</span>
            <span class="control-value">{{ refraction.toFixed(2) }}</span>
          </div>
          <div class="slider-container" @mousedown.stop @touchstart.stop>
            <input
              v-model.number="refraction"
              type="range"
              min="0.1"
              max="0.25"
              step="0.01"
              class="native-slider"
            />
          </div>
        </div>

        <!-- Depth -->
        <div class="control-item">
          <div class="control-header">
            <span class="control-label">Depth 深度</span>
            <span class="control-value">{{ depth }}</span>
          </div>
          <div class="slider-container" @mousedown.stop @touchstart.stop>
            <input
              v-model.number="depth"
              type="range"
              min="4"
              max="16"
              step="1"
              class="native-slider"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.glass-effect-page {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  user-select: none;
}

/* 背景层 */
.background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.background-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url('/src/assets/bg.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  opacity: 0.9;
}

.background-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: 
    radial-gradient(circle at 25% 25%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 75% 75%, rgba(255, 255, 255, 0.05) 0%, transparent 50%);
  background-size: 300px 300px, 200px 200px;
}

/* 玻璃面板 - 应用用户提供的样式 */
.glass-panel {
  position: fixed;
  width: 320px;
  min-height: 400px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(21px);
  -webkit-backdrop-filter: blur(21px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 
    0 8px 32px rgba(0, 0, 0, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.5),
    inset 0 -1px 0 rgba(255, 255, 255, 0.1),
    inset 0 0 16px 8px rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  padding: 24px;
  cursor: grab;
  transition: transform 0.1s ease-out;
  z-index: 100;
  touch-action: none;
}

.glass-panel:active {
  cursor: grabbing;
}

/* 使用伪元素实现用户提供的高光效果 */
.glass-panel::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.8),
    transparent
  );
  z-index: 1;
}

.glass-panel::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 1px;
  height: 100%;
  background: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.8),
    transparent,
    rgba(255, 255, 255, 0.3)
  );
  z-index: 1;
}

/* 拖拽手柄 */
.drag-handle {
  position: absolute;
  top: 8px;
  left: 50%;
  transform: translateX(-50%);
  width: 40px;
  height: 4px;
  border-radius: 2px;
  background: rgba(255, 255, 255, 0.4);
  cursor: grab;
  z-index: 2;
}

.drag-handle:active {
  cursor: grabbing;
}

.handle-indicator {
  width: 100%;
  height: 100%;
  border-radius: inherit;
  background: rgba(255, 255, 255, 0.6);
}

/* 面板头部 */
.panel-header {
  margin-top: 16px;
  margin-bottom: 24px;
  position: relative;
  z-index: 2;
}

.panel-title {
  font-size: 24px;
  font-weight: 600;
  color: white;
  margin: 0;
  text-align: left;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

/* 控制项 */
.controls {
  display: flex;
  flex-direction: column;
  gap: 24px;
  position: relative;
  z-index: 2;
}

.control-item {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.control-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.control-label {
  font-size: 16px;
  font-weight: 500;
  color: white;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.control-value {
  font-size: 16px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  min-width: 50px;
  text-align: right;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

/* 原生滑块样式 */
.slider-container {
  position: relative;
  padding: 8px 0;
  touch-action: auto;
}

.native-slider {
  width: 100%;
  height: 8px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.15);
  outline: none;
  border: none;
  cursor: pointer;
  appearance: none;
  -webkit-appearance: none;
}

/* Webkit浏览器样式 */
.native-slider::-webkit-slider-track {
  width: 100%;
  height: 8px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
}

.native-slider::-webkit-slider-thumb {
  appearance: none;
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.85));
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 
    0 2px 8px rgba(0, 0, 0, 0.15),
    0 0 0 2px rgba(255, 255, 255, 0.2),
    inset 0 1px 0 rgba(255, 255, 255, 0.9);
  cursor: pointer;
}

/* Firefox浏览器样式 */
.native-slider::-moz-range-track {
  width: 100%;
  height: 8px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
}

.native-slider::-moz-range-thumb {
  height: 20px;
  width: 20px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.85));
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 
    0 2px 8px rgba(0, 0, 0, 0.15),
    0 0 0 2px rgba(255, 255, 255, 0.2),
    inset 0 1px 0 rgba(255, 255, 255, 0.9);
  cursor: pointer;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .glass-panel {
    width: 280px;
    min-height: 380px;
    padding: 20px;
  }
  
  .panel-title {
    font-size: 20px;
  }
  
  .control-label {
    font-size: 14px;
  }
  
  .control-value {
    font-size: 14px;
  }
  
  .slider-thumb {
    width: 24px;
    height: 24px;
  }
}

/* 触摸设备优化 */
@media (hover: none) {
  .glass-panel {
    cursor: default;
  }
  
  .drag-handle {
    cursor: default;
  }
  
  .slider-thumb {
    width: 26px;
    height: 26px;
  }
}

/* 安全区域适配 */
@supports (padding: max(0px)) {
  .glass-panel {
    padding-left: max(24px, env(safe-area-inset-left));
    padding-right: max(24px, env(safe-area-inset-right));
    padding-bottom: max(24px, env(safe-area-inset-bottom));
  }
}
</style> 