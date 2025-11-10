import requestBase from './base';

// request my message list
export async function getMessageList(loginToken) {

    // 构建请求的基础 URL
    let requestUrl = `/api/message/list`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request my message unread count
export async function getMessageUnreadCount(loginToken, from) {

    // 构建请求的基础 URL
    let requestUrl = `/api/message/unread?from=${from}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request mark message as read
export async function markAsRead(loginToken, id) {

    // 构建请求的基础 URL
    let requestUrl = `/api/message/markread`;

    const response = await requestBase.post(requestUrl, {
        id
    }, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}
