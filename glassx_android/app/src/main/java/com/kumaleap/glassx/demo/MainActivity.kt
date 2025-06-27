package com.kumaleap.glassx.demo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.input.nestedscroll.NestedScrollConnection
import androidx.compose.ui.input.nestedscroll.NestedScrollSource
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.bumptech.glide.integration.compose.ExperimentalGlideComposeApi
import com.bumptech.glide.integration.compose.GlideImage
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.RequestOptions
import jp.wasabeef.glide.transformations.BlurTransformation
import androidx.compose.ui.graphics.toArgb
import com.kumaleap.glassx.demo.ui.theme.Glassx_androidTheme
import kotlin.math.roundToInt
//import androidx.compose.ui.viewinterop.AndroidView
//import eightbitlab.com.blurview.BlurView
//import eightbitlab.com.blurview.RenderScriptBlur
//import android.app.Activity

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Glassx_androidTheme {
                GlassEffectScreen()
            }
        }
    }
}

@Composable
fun GlassEffectScreen() {
    // 状态变量
    var blurValue by remember { mutableStateOf(21f) }
    var refraction by remember { mutableStateOf(0.15f) }
    var depth by remember { mutableStateOf(8f) }
    var panelOffset by remember { mutableStateOf(Offset(0f, 0f)) }
    
    val configuration = LocalConfiguration.current
    val density = LocalDensity.current
    
    // 计算面板居中位置
    val screenWidth = configuration.screenWidthDp.dp
    val screenHeight = configuration.screenHeightDp.dp
    val panelWidth = 280.dp
    val panelHeight = 360.dp
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(top = 24.dp) // 替代systemBarsPadding
    ) {
        // 背景层
        BackgroundLayer()
        
        // 可拖拽的毛玻璃设置面板
        GlassPanel(
            blurValue = blurValue,
            refraction = refraction,
            depth = depth,
            panelOffset = panelOffset,
            onOffsetChange = { newOffset ->
                val maxX = with(density) { (screenWidth - panelWidth).toPx() / 2 }
                val maxY = with(density) { (screenHeight - panelHeight).toPx() / 2 }
                panelOffset = Offset(
                    x = newOffset.x.coerceIn(-maxX, maxX),
                    y = newOffset.y.coerceIn(-maxY, maxY)
                )
            },
            onBlurChange = { blurValue = it },
            onRefractionChange = { refraction = it },
            onDepthChange = { depth = it },
            modifier = Modifier
                .size(panelWidth, panelHeight)
                .offset {
                    IntOffset(
                        x = panelOffset.x.roundToInt(),
                        y = panelOffset.y.roundToInt()
                    )
                }
                .align(Alignment.Center)
        )
    }
}

@OptIn(ExperimentalGlideComposeApi::class)
@Composable
fun BackgroundLayer() {
    Box(modifier = Modifier.fillMaxSize()) {
        // 增强的渐变背景
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.linearGradient(
                        colors = listOf(
                            Color(0xFF667EEA),
                            Color(0xFF764BA2),
                            Color(0xFF667EEA),
                            Color(0xFF8360C3)
                        ),
                        start = Offset(0f, 0f),
                        end = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY)
                    )
                )
        )
        
        // 使用Glide加载背景图片，支持内存优化
        GlideImage(
            model = R.drawable.bg,
            contentDescription = "Background",
            modifier = Modifier
                .fillMaxSize()
                .graphicsLayer(alpha = 0.9f),
            contentScale = ContentScale.Crop,
            requestBuilderTransform = { requestBuilder ->
                requestBuilder
                    .apply(
                        RequestOptions()
                            .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                            .override(800, 1200) // 限制尺寸避免内存问题
                            .centerCrop()
                    )
            }
        )
        
        // 装饰性渐变叠加
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.radialGradient(
                        colors = listOf(
                            Color.White.copy(alpha = 0.1f),
                            Color.Transparent
                        ),
                        center = Offset(0f, 0f),
                        radius = 300f
                    )
                )
        )
        
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.radialGradient(
                        colors = listOf(
                            Color.White.copy(alpha = 0.05f),
                            Color.Transparent
                        ),
                        center = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY),
                        radius = 200f
                    )
                )
        )
    }
}

@OptIn(ExperimentalGlideComposeApi::class)
@Composable
fun BlurredBackground(
    blurRadius: Float,
    modifier: Modifier = Modifier
) {
    // 使用Glide的BlurTransformation创建真实的模糊背景
    GlideImage(
        model = R.drawable.bg,
        contentDescription = "Blurred Background",
        modifier = modifier,
        contentScale = ContentScale.Crop,
        requestBuilderTransform = { requestBuilder ->
            requestBuilder
                .apply(
                    RequestOptions()
                        .transform(BlurTransformation((blurRadius * 2).toInt().coerceIn(1, 25)))
                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                        .override(400, 600) // 更小的尺寸用于模糊效果
                )
        }
    )
}

/*
@Composable
fun BlurContainer(
    blurRadius: Float,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    
    AndroidView(
        factory = { ctx ->
            BlurView(ctx).apply {
                try {
                    val activity = context as? Activity
                    val rootView = activity?.findViewById<android.view.ViewGroup>(android.R.id.content)
                    if (rootView != null) {
                        @Suppress("DEPRECATION")
                        setupWith(rootView, RenderScriptBlur(context))
                            .setBlurRadius(blurRadius.coerceIn(0f, 25f))
                            .setBlurAutoUpdate(true)
                    }
                } catch (e: Exception) {
                    // 如果BlurView设置失败，只显示普通视图
                    e.printStackTrace()
                }
            }
        },
        modifier = modifier,
        update = { blurView ->
            try {
                blurView.setBlurRadius(blurRadius.coerceIn(0f, 25f))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    )
}
*/

@Composable
fun GlassPanel(
    blurValue: Float,
    refraction: Float,
    depth: Float,
    panelOffset: Offset,
    onOffsetChange: (Offset) -> Unit,
    onBlurChange: (Float) -> Unit,
    onRefractionChange: (Float) -> Unit,
    onDepthChange: (Float) -> Unit,
    modifier: Modifier = Modifier
) {
    // 计算动态属性
    val borderOpacity = 0.25f + (depth - 4f) / (16f - 4f) * 0.25f
    val shadowElevation = (depth * 3).dp
    
    // 移除nestedScroll以避免干扰滑块触摸事件
    
    Box(
        modifier = modifier
            .shadow(
                elevation = shadowElevation,
                shape = RoundedCornerShape(16.dp),
                ambientColor = Color.Black.copy(alpha = 0.12f + depth * 0.008f),
                spotColor = Color.Black.copy(alpha = 0.12f + depth * 0.008f)
            )
    ) {
        // 真实的模糊背景
        BlurredBackground(
            blurRadius = blurValue,
            modifier = Modifier
                .fillMaxSize()
                .graphicsLayer(alpha = 0.8f)
                .background(
                    Color.Transparent,
                    RoundedCornerShape(16.dp)
                )
        )
        
        // 毛玻璃叠加效果
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.linearGradient(
                        colors = listOf(
                            Color.White.copy(alpha = refraction * 0.4f),
                            Color.White.copy(alpha = refraction * 0.2f),
                            Color.White.copy(alpha = refraction * 0.3f)
                        ),
                        start = Offset(0f, 0f),
                        end = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY)
                    ),
                    RoundedCornerShape(16.dp)
                )
        )
        
        // 折射光效果
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.radialGradient(
                        colors = listOf(
                            Color.White.copy(alpha = refraction * 0.2f),
                            Color.Transparent,
                            Color(0xFF667EEA).copy(alpha = refraction * 0.1f)
                        ),
                        center = Offset(0.8f, 0.2f),
                        radius = blurValue * 10f + 50f
                    ),
                    RoundedCornerShape(16.dp)
                )
        )
        
        // 内容层 - 在最上层，带边框
        Card(
            modifier = Modifier.fillMaxSize(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(
                containerColor = Color.Transparent
            ),
            border = androidx.compose.foundation.BorderStroke(
                width = 1.dp,
                brush = Brush.linearGradient(
                    colors = listOf(
                        Color.White.copy(alpha = borderOpacity),
                        Color.White.copy(alpha = borderOpacity * 0.3f)
                    ),
                    start = Offset(0f, 0f),
                    end = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY)
                )
            )
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(
                        // 增强内容背景，确保更好的可读性
                        Brush.linearGradient(
                            colors = listOf(
                                Color.Black.copy(alpha = 0.3f),
                                Color.Black.copy(alpha = 0.1f),
                                Color.Black.copy(alpha = 0.2f)
                            ),
                            start = Offset(0f, 0f),
                            end = Offset(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY)
                        ),
                        RoundedCornerShape(16.dp)
                    )
                    .padding(20.dp),
                verticalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                // 可拖拽的标题区域
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .pointerInput(Unit) {
                            detectDragGestures { _, dragAmount ->
                                onOffsetChange(panelOffset + dragAmount)
                            }
                        }
                        .padding(vertical = 6.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    // 拖拽手柄
                    Box(
                        modifier = Modifier
                            .width(36.dp)
                            .height(3.dp)
                            .background(
                                Color.White.copy(alpha = 0.7f),
                                RoundedCornerShape(2.dp)
                            )
                    )
                    
                    // 标题
                    Text(
                        text = "Glass Settings",
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White,
                        modifier = Modifier
                            .background(
                                Color.Black.copy(alpha = 0.2f),
                                RoundedCornerShape(8.dp)
                            )
                            .padding(horizontal = 12.dp, vertical = 4.dp)
                    )
                }
                
                // 控制项
                Column(
                    verticalArrangement = Arrangement.spacedBy(18.dp)
                ) {
                    // Blur value
                    ControlItem(
                        label = "Blur value",
                        value = String.format("%.0f", blurValue),
                        sliderValue = blurValue,
                        valueRange = 0f..25f,
                        onValueChange = onBlurChange
                    )
                    
                    // Refraction
                    ControlItem(
                        label = "Refraction 折射",
                        value = String.format("%.2f", refraction),
                        sliderValue = refraction,
                        valueRange = 0.1f..0.25f,
                        onValueChange = onRefractionChange
                    )
                    
                    // Depth
                    ControlItem(
                        label = "Depth 深度",
                        value = String.format("%.0f", depth),
                        sliderValue = depth,
                        valueRange = 4f..16f,
                        onValueChange = onDepthChange
                    )
                }
            }
        }
    }
}

@Composable
fun ControlItem(
    label: String,
    value: String,
    sliderValue: Float,
    valueRange: ClosedFloatingPointRange<Float>,
    onValueChange: (Float) -> Unit
) {
    Column(
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = label,
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium,
                color = Color.White,
                modifier = Modifier
                    .background(
                        Color.Black.copy(alpha = 0.15f),
                        RoundedCornerShape(6.dp)
                    )
                    .padding(horizontal = 8.dp, vertical = 2.dp)
            )
            
            Text(
                text = value,
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White,
                modifier = Modifier
                    .background(
                        Color.Black.copy(alpha = 0.15f),
                        RoundedCornerShape(6.dp)
                    )
                    .padding(horizontal = 8.dp, vertical = 2.dp)
            )
        }
        
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    Color.Black.copy(alpha = 0.1f),
                    RoundedCornerShape(12.dp)
                )
                .padding(horizontal = 8.dp, vertical = 4.dp)
        ) {
            Slider(
                value = sliderValue,
                onValueChange = onValueChange,
                valueRange = valueRange,
                colors = SliderDefaults.colors(
                    thumbColor = Color.White,
                    activeTrackColor = Color(0xFF667EEA).copy(alpha = 0.8f),
                    inactiveTrackColor = Color.White.copy(alpha = 0.4f)
                ),
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GlassEffectPreview() {
    Glassx_androidTheme {
        GlassEffectScreen()
    }
}