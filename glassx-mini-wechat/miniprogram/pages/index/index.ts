// index.ts
// 获取应用实例
const app = getApp<IAppOption>()

Component({
  data: {
    // 毛玻璃效果参数
    blurValue: 21,
    refraction: 0.15,
    depth: 8,
    
    // 面板位置
    panelX: 20,
    panelY: 150,
    
    // 计算属性
    refractionDisplay: '0.15',
    refractionSlider: 15, // 0.15 * 100 = 15
    shadowStyle: '0 16px 32px rgba(0, 0, 0, 0.15), 0 8px 16px rgba(0, 0, 0, 0.12), 0 4px 8px rgba(0, 0, 0, 0.08)',
    borderOpacity: 0.35, // 基于深度的边框透明度
  },

  lifetimes: {
    attached() {
      // 初始化面板位置
      const systemInfo = wx.getSystemInfoSync()
      const centerX = Math.max(0, (systemInfo.windowWidth - 320) / 2)
      const centerY = Math.max(0, (systemInfo.windowHeight - 500) / 2)
      
      // 初始化阴影样式和边框透明度
      const initialShadowStyle = this.calculateShadowStyle(this.data.depth)
      const initialBorderOpacity = 0.25 + (this.data.depth - 4) / (16 - 4) * 0.25
      
      this.setData({
        panelX: centerX,
        panelY: centerY,
        shadowStyle: initialShadowStyle,
        borderOpacity: initialBorderOpacity
      })
    }
  },

  methods: {
    // 计算阴影样式
    calculateShadowStyle(depth: number) {
      const mainShadow = `0 ${depth * 3}px ${depth * 6}px rgba(0, 0, 0, ${0.12 + depth * 0.008})`
      const mediumShadow = `0 ${depth * 2}px ${depth * 4}px rgba(0, 0, 0, ${0.08 + depth * 0.006})`
      const smallShadow = `0 ${depth}px ${depth * 2}px rgba(0, 0, 0, ${0.04 + depth * 0.004})`
      return `${mainShadow}, ${mediumShadow}, ${smallShadow}`
    },

    // Blur value 滑块变化
    onBlurChange(e: any) {
      const value = e.detail.value
      this.setData({
        blurValue: value
      })
    },

    // Refraction 滑块变化（处理小数）
    onRefractionChange(e: any) {
      const sliderValue = e.detail.value
      const actualValue = sliderValue / 100  // 将 10-25 映射到 0.1-0.25
      this.setData({
        refractionSlider: sliderValue,
        refraction: actualValue,
        refractionDisplay: actualValue.toFixed(2)
      })
    },

    // Depth 滑块变化
    onDepthChange(e: any) {
      const value = e.detail.value
      const shadowStyle = this.calculateShadowStyle(value)
      // 深度越大，边框越亮，范围从0.25到0.5
      const borderOpacity = 0.25 + (value - 4) / (16 - 4) * 0.25
      this.setData({
        depth: value,
        shadowStyle: shadowStyle,
        borderOpacity: borderOpacity
      })
    },
  },
})
