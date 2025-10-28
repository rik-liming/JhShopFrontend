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
    const { payment_method, page, page_size } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order_listing/page?page=${page}&page_size=${page_size}&payment_method=${payment_method}`;
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
