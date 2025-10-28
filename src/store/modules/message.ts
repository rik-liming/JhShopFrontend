import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'

export default defineStore({
  id: 'message',
  state: () => ({
    readMessageIds: useStorage<string[]>('readMessageIds', []),
  }),
  getters: {
    // 判断某条消息是否已读
    isRead: (state) => (id: string) => state.readMessageIds.includes(id),
  },
  actions: {
    // 添加已读消息 ID
    addReadMessage(id: string) {
      if (!this.readMessageIds.includes(id)) {
        this.readMessageIds.push(id)
      }
    },

    // 批量添加（可选）
    addReadMessages(ids: string[]) {
      const set = new Set([...this.readMessageIds, ...ids])
      this.readMessageIds = Array.from(set)
    },

    clear() {
      this.readMessageIds = []
    },
  },
})
