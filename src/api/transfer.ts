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
export async function getTransferDetail(loginToken, id) {

    // 构建请求的基础 URL
    let requestUrl = `/api/transfer/detail?id=${id}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}