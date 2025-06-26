import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'glass-effect',
      component: () => import('../views/GlassEffectView.vue'),
    },
  ],
})

export default router
