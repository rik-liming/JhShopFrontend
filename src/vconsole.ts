// src/plugins/vconsole.ts
import VConsole from 'vconsole'

/**
 * 初始化 vConsole，仅在开发环境 + 移动端访问时启用
 */
export function setupVConsole() {
  const isDev = import.meta.env.MODE === 'development'
  const isMobile = /Android|iPhone|iPad|iPod|iOS/i.test(navigator.userAgent)

  if (isDev && isMobile) {
    // 避免重复实例化
    if (!(window as any).__VCONSOLE__) {
      (window as any).__VCONSOLE__ = new VConsole()
	  console.log('[vConsole] 已启用移动端调试工具')
    }
  } else {
	console.log('[vConsole] 当前环境不启用')
  }
}
