import requestBase from './base';

// request create recharge
export async function createRecharge(loginToken, formData) {
    const response = await requestBase.post('/api/recharge', formData, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
            'Content-Type': 'multipart/form-data',
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