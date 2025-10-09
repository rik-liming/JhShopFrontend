import requestBase from './base';

// request create order listing
export async function createOrderListing(loginToken, orderParams) {
    const response = await requestBase.post('/api/order_listing', orderParams, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request order listing
export async function getOrderListingByPage(loginToken, queryParams) {
    const { channel, page, pagesize } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order_listing/page?page=${page}&pagesize=${pagesize}&channel=${channel}`;
    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request orderlisting info
export async function getOrderListing(loginToken, listingId) {
    const response = await requestBase.get(`/api/order_listing?id=${listingId}`, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

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
    const { channel, page, pagesize } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order/buyer/my?page=${page}&pagesize=${pagesize}&channel=${channel}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request seller order
export async function getMySellerOrder(loginToken, queryParams) {
    const { channel, page, pagesize } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order/seller/my?page=${page}&pagesize=${pagesize}&channel=${channel}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}