import requestBase from './base';

// request create withdraw
export async function createWithdraw(loginToken, data) {
    const response = await requestBase.post('/api/withdraw', data, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request withdraw detail
export async function getWithdrawDetail(loginToken, id) {

    // 构建请求的基础 URL
    let requestUrl = `/api/withdraw/detail?id=${id}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}