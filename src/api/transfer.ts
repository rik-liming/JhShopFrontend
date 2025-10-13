import requestBase from './base';

// request create transfer
export async function createTransfer(loginToken, data) {
    const response = await requestBase.post('/api/transfer', data, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request transfer detail
export async function getTransferDetail(loginToken, transactionId) {

    // 构建请求的基础 URL
    let requestUrl = `/api/transfer/detail?transaction_id=${transactionId}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}