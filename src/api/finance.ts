import requestBase from './base';

// request my finance records
export async function getMyFinanceRecord(loginToken, queryParams) {
    const { channel, page, pagesize } = queryParams;

    // 构建请求的基础 URL
    let requestUrl = `/api/financial_record/my?page=${page}&pagesize=${pagesize}`;
    if (channel) {
        requestUrl += `&channel=${channel}`
    }

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}
