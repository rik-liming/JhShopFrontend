import requestBase from './base';

// request create order listing
export async function createOrderListing(loginToken, orderParams) {
    const response = await requestBase.post('/api/order-listing', orderParams, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request order listing
export async function getOrderListing(loginToken, queryParams) {
    const { channel, page, pagesize } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/order-listing/page?page=${page}&pagesize=${pagesize}&channel=${channel}`;
    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request user list
export async function fetchUserList(adminLoginToken, queryParams) {
    const { page, pagesize, keyword, role } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/admin/user/page?page=${page}&pagesize=${pagesize}`;
    if (keyword) {
        requestUrl += `&keyword=${encodeURIComponent(keyword)}`;
    }
    if (role) {
        requestUrl += `&role=${role}`;
    }
    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${adminLoginToken}`,
        }
    })
    return response
}