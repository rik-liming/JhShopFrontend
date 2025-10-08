export function formatIdDisplay(id) {
    return `JH${id.toString().padStart(4, '0')}`;
}

export function formatRole(role) {
    const roleMap = {
        'agent': '代理',
        'seller': '商家',
        'buyer': '买家',
        'default': '默认用户'
    }
    return roleMap[role]
}