import requestBase from './base';

// request create recharge
export async function createRecharge(loginToken, data) {
    const response = await requestBase.post('/api/recharge', data, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request recharge detail
export async function getRechargeDetail(loginToken, transactionId) {

    // 构建请求的基础 URL
    let requestUrl = `/api/recharge/detail?transaction_id=${transactionId}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}