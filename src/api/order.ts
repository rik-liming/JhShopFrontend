import requestBase from './base';

// request order create
export async function createOrder(loginToken, data) {
    const response = await requestBase.post('/api/order', data, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request buyer order
export async function getMyBuyerOrder(loginToken, queryParams) {
    const { payment_method, page, page_size } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order/buyer/my?page=${page}&page_size=${page_size}`;
    if (payment_method) {
        requestUrl += `&payment_method=${payment_method}`
    }

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request seller order
export async function getMySellerOrder(loginToken, queryParams) {
    const { payment_method, page, page_size } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order/seller/my?page=${page}&page_size=${page_size}`;
    if (payment_method) {
        requestUrl += `&payment_method=${payment_method}`
    }

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request order detail
export async function getOrderDetail(loginToken, orderId) {

    // 构建请求的基础 URL
    let requestUrl = `/api/order/detail?orderId=${orderId}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request order confirm
export async function orderConfirm(loginToken, data) {
    const response = await requestBase.post('/api/order/confirm', data, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request my order report
export async function getMyOrderReport(loginToken, queryParams) {

    const { startTime, endTime } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order/report/my?startTime=${startTime}&endTime=${endTime}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request group order report
export async function getGroupOrderReport(loginToken) {

    // 构建请求的基础 URL
    let requestUrl = `/api/order/report/group`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request order create
export async function createAutoBuyerOrder(data) {
    const response = await requestBase.post('/api/order/auto_buyer', data)
    return response
}

// request order detail
export async function getAutoBuyerOrderDetail(orderId) {

    // 构建请求的基础 URL
    let requestUrl = `/api/order/auto_buyer/detail?orderId=${orderId}`;

    const response = await requestBase.get(requestUrl)
    return response
}

// request order confirm
export async function autoBuyerOrderConfirm(data) {
    const response = await requestBase.post('/api/order/auto_buyer/confirm', data)
    return response
}