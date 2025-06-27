@Entry
@Component
struct Index {
  // 毛玻璃效果参数
  @State blurValue: number = 21;
  @State refraction: number = 0.15;
  @State depth: number = 8;
  
  // 玻璃面板位置和拖拽状态
  @State panelX: number = 20;
  @State panelY: number = 150;
  @State isDragging: boolean = false;
  @State dragOffsetX: number = 0;
  @State dragOffsetY: number = 0;



  // 处理拖拽开始
  onPanStart(event: GestureEvent) {
    this.isDragging = true;
    this.dragOffsetX = event.fingerList[0].globalX - this.panelX;
    this.dragOffsetY = event.fingerList[0].globalY - this.panelY;
  }

  // 处理拖拽过程
  onPanUpdate(event: GestureEvent) {
    if (!this.isDragging) return;
    
    const newX = event.fingerList[0].globalX - this.dragOffsetX;
    const newY = event.fingerList[0].globalY - this.dragOffsetY;
    
    // 限制在屏幕范围内（假设屏幕宽度400，高度800）
    this.panelX = Math.max(0, Math.min(newX, 120)); // 400 - 280 = 120
    this.panelY = Math.max(20, Math.min(newY, 380)); // 800 - 420 = 380
  }

  // 处理拖拽结束
  onPanEnd() {
    this.isDragging = false;
  }



  build() {
    Stack() {
      // 背景层
      Image($r('app.media.bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .opacity(0.9)



      // 可拖拽的毛玻璃设置面板
      Stack() {
        // 高光效果
        Column() {
          // 顶部高光
          Row()
            .width('100%')
            .height(1)
            .linearGradient({
              direction: GradientDirection.Left,
              colors: [
                ['transparent', 0.0],
                ['rgba(255, 255, 255, 0.8)', 0.5],
                ['transparent', 1.0]
              ]
            })
            .position({ x: 0, y: 0 })
        }
        .width('100%')
        .height('100%')

        // 面板内容
        Column() {
          // 拖拽区域（包含手柄和标题）
          Column() {
            // 拖拽手柄
            Row()
              .width(40)
              .height(4)
              .backgroundColor('rgba(255, 255, 255, 0.6)')
              .borderRadius(2)
              .margin({ top: 8, bottom: 16 })

            // 设置标题
            Text('Settings')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ bottom: 24 })
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .width('100%')
          .gesture(
            PanGesture({ fingers: 1, direction: PanDirection.All, distance: 1 })
              .onActionStart((event: GestureEvent) => {
                this.onPanStart(event);
              })
              .onActionUpdate((event: GestureEvent) => {
                this.onPanUpdate(event);
              })
              .onActionEnd(() => {
                this.onPanEnd();
              })
          )

          // 控制项容器
          Column({ space: 24 }) {
            // Blur value
            Column({ space: 12 }) {
              Row() {
                Text('Blur value')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.White)
                Blank()
                Text(this.blurValue.toString())
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('rgba(255, 255, 255, 0.9)')
              }
              .width('100%')

              Row() {
                Slider({
                  value: this.blurValue,
                  min: 0,
                  max: 50,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .width('100%')
                  .trackThickness(8)
                  .selectedColor(Color.White)
                  .trackColor('rgba(255, 255, 255, 0.15)')
                  .blockColor(Color.White)
                  .blockSize({ width: 20, height: 20 })
                  .onChange((value: number) => {
                    this.blurValue = value;
                  })
              }
              .padding({ top: 8, bottom: 8 })
            }

            // Refraction
            Column({ space: 12 }) {
              Row() {
                Text('Refraction 折射')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.White)
                Blank()
                Text(this.refraction.toFixed(2))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('rgba(255, 255, 255, 0.9)')
              }
              .width('100%')

              Row() {
                Slider({
                  value: this.refraction,
                  min: 0.1,
                  max: 0.25,
                  step: 0.01,
                  style: SliderStyle.OutSet
                })
                  .width('100%')
                  .trackThickness(8)
                  .selectedColor(Color.White)
                  .trackColor('rgba(255, 255, 255, 0.15)')
                  .blockColor(Color.White)
                  .blockSize({ width: 20, height: 20 })
                  .onChange((value: number) => {
                    this.refraction = value;
                  })
              }
              .padding({ top: 8, bottom: 8 })
            }

            // Depth
            Column({ space: 12 }) {
              Row() {
                Text('Depth 深度')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.White)
                Blank()
                Text(this.depth.toString())
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('rgba(255, 255, 255, 0.9)')
              }
              .width('100%')

              Row() {
                Slider({
                  value: this.depth,
                  min: 4,
                  max: 16,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .width('100%')
                  .trackThickness(8)
                  .selectedColor(Color.White)
                  .trackColor('rgba(255, 255, 255, 0.15)')
                  .blockColor(Color.White)
                  .blockSize({ width: 20, height: 20 })
                  .onChange((value: number) => {
                    this.depth = value;
                  })
              }
              .padding({ top: 8, bottom: 8 })
            }
          }
        }
        .padding(20)
      }
      .width(280)
      .height(420)
      .backgroundColor(`rgba(255, 255, 255, ${this.refraction})`)
      .backdropBlur(this.blurValue)
      .borderRadius(20)
      .border({ width: 1, color: 'rgba(255, 255, 255, 0.3)' })
      .shadow({
        radius: this.depth * 6,
        color: `rgba(0, 0, 0, ${0.1 + this.depth * 0.02})`,
        offsetX: 0,
        offsetY: this.depth * 2
      })
      .position({ x: this.panelX, y: this.panelY })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#667eea')
  }
}