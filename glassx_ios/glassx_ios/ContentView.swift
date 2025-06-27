//
//  ContentView.swift
//  glassx_ios
//
//  Created by 大熊 on 2025/6/26.
//

import SwiftUI

// iOS原生Blur组件 - 简化版本
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        uiView.effect = blurEffect
    }
}

struct ContentView: View {
    @State private var blurValue: Double = 21
    @State private var refraction: Double = 0.15
    @State private var depth: Double = 8
    @State private var panelOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景层
                backgroundView
                
                // 可拖拽的毛玻璃设置面板
                glassPanel
                    .offset(panelOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                panelOffset = value.translation
                            }
                            .onEnded { _ in
                                // 边界限制
                                let maxX = (geometry.size.width - 280) / 2
                                let maxY = (geometry.size.height - 360) / 2
                                panelOffset.width = max(-maxX, min(maxX, panelOffset.width))
                                panelOffset.height = max(-maxY, min(maxY, panelOffset.height))
                            }
                    )
            }
            .ignoresSafeArea()
        }
    }
    
    // 背景视图
    private var backgroundView: some View {
        ZStack {
            // 渐变背景
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.498, blue: 0.918),
                    Color(red: 0.463, green: 0.294, blue: 0.635)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // 背景图片
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.9)
            
            // 装饰性渐变叠加
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 300
            )
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.05),
                    Color.clear
                ]),
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 200
            )
        }
    }
    
    // 毛玻璃面板 - 六层强化效果
    private var glassPanel: some View {
        ZStack {
            // 第一层：blur响应的UIKit blur背景
            VisualEffectBlur(blurStyle: dynamicBlurStyle)
                .opacity(0.4 + blurValue * 0.01)
            
            // 第二层：blur响应的SwiftUI材质
            RoundedRectangle(cornerRadius: 16)
                .fill(dynamicMaterial)
                .opacity(0.3 + blurValue * 0.008)
            
            // 第三层：blur增强的白色毛玻璃叠加
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(refraction * (1.5 + blurValue * 0.03)),
                            Color.white.opacity(refraction * (0.8 + blurValue * 0.02)),
                            Color.white.opacity(refraction * (1.2 + blurValue * 0.025))
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // 第四层：blur响应的折射光效果
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(refraction * (0.6 + blurValue * 0.012)),
                            Color.white.opacity(refraction * (0.15 + blurValue * 0.004)),
                            Color(red: 0.4, green: 0.498, blue: 0.918).opacity(refraction * (0.3 + blurValue * 0.006))
                        ],
                        center: UnitPoint(x: 0.8, y: 0.2),
                        startRadius: blurValue * 0.8 + 10,
                        endRadius: blurValue * 3.0 + 60
                    )
                )
            
            // 第五层：blur控制的光晕效果  
            if blurValue > 3 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(refraction * (0.4 + blurValue * 0.008)),
                                Color.clear
                            ],
                            center: UnitPoint(x: 0.2, y: 0.8),
                            startRadius: blurValue * 0.5 + 5,
                            endRadius: blurValue * 2.0 + 40
                        )
                    )
            }
            
            // 第六层：blur响应的边框高光
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(refraction * (1.0 + blurValue * 0.02)),
                            Color.white.opacity(refraction * (0.25 + blurValue * 0.005)),
                            Color.white.opacity(refraction * (0.75 + blurValue * 0.015))
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1 + blurValue * 0.02
                )
            
            // 内容区域
            VStack(spacing: 0) {
                // 拖拽区域 - 只有上方区域可以拖拽
                VStack(spacing: 8) {
                    // 拖拽指示器
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 36, height: 3)
                        .padding(.top, 8)
                    
                    // 标题
                    Text("Glass Settings")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        .padding(.bottom, 8)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)
                
                // 参数控制区域
                VStack(spacing: 20) {
                    // Blur value
                    modernControlItem(
                        label: "Blur value",
                        value: String(format: "%.0f", blurValue),
                        range: 0...50,
                        binding: $blurValue
                    )
                    
                    // Refraction 折射
                    modernControlItem(
                        label: "Refraction 折射",
                        value: String(format: "%.2f", refraction),
                        range: 0.10...0.25,
                        binding: $refraction
                    )
                    
                    // Depth 深度
                    modernControlItem(
                        label: "Depth 深度",
                        value: String(format: "%.0f", depth),
                        range: 4...16,
                        binding: $depth
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                Spacer()
            }
        }
        .frame(width: 280, height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(borderOpacity),
                            Color.white.opacity(borderOpacity * 0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(
            color: .black.opacity(shadowOpacity),
            radius: shadowRadius,
            x: 0,
            y: shadowOffset
        )
        .shadow(
            color: .black.opacity(shadowOpacity * 0.5),
            radius: shadowRadius * 0.8,
            x: shadowOffset * 0.3,
            y: shadowOffset * 0.8
        )
        .shadow(
            color: .black.opacity(shadowOpacity * 0.2),
            radius: shadowRadius * 1.5,
            x: 0,
            y: shadowOffset * 1.2
        )
    }
    
    // 动态SwiftUI材质 - 高度敏感响应
    private var dynamicMaterial: Material {
        if blurValue < 5 {
            return .ultraThin
        } else if blurValue < 12 {
            return .thin
        } else if blurValue < 25 {
            return .regular
        } else if blurValue < 40 {
            return .thick
        } else {
            return .ultraThick
        }
    }
    
    // 动态blur样式计算 - 精细级别切换
    private var dynamicBlurStyle: UIBlurEffect.Style {
        if blurValue < 3 {
            return .systemUltraThinMaterial
        } else if blurValue < 10 {
            return .systemThinMaterial
        } else if blurValue < 20 {
            return .systemMaterial
        } else if blurValue < 35 {
            return .systemThickMaterial
        } else {
            return .systemChromeMaterial
        }
    }
    
    // 现代化控制项组件 - 更接近H5风格
    private func modernControlItem(label: String, value: String, range: ClosedRange<Double>, binding: Binding<Double>) -> some View {
        VStack(spacing: 10) {
            // 标签和数值行
            HStack {
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                    .frame(minWidth: 45, alignment: .trailing)
            }
            
            // 滑块 - 类似H5的白色主题
            HStack {
                Slider(value: binding, in: range)
                    .accentColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.1))
                            .frame(height: 6)
                    )
            }
            .padding(.horizontal, 4)
        }
        .padding(.horizontal, 4)
    }
    
    // 计算属性：边框透明度 - 增强范围
    private var borderOpacity: Double {
        0.3 + (depth - 4) / (16 - 4) * 0.4
    }
    
    // 计算属性：阴影透明度 - 更明显的变化
    private var shadowOpacity: Double {
        0.15 + depth * 0.015
    }
    
    // 计算属性：阴影半径 - 增强立体感
    private var shadowRadius: Double {
        depth * 4
    }
    
    // 计算属性：阴影偏移 - 更明显的偏移
    private var shadowOffset: Double {
        depth * 2.5
    }
}

#Preview {
    ContentView()
}
