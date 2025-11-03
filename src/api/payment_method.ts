import requestBase from './base';

// request my list
export async function getMyList(loginToken) {

    // 构建请求的基础 URL
    let requestUrl = `/api/payment_method/my`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request create payment method
export async function createPaymentMethod(loginToken, formData) {
    const response = await requestBase.post('/api/payment_method', formData, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
            'Content-Type': 'multipart/form-data',
        }
    })
    return response
}

// request update payment method
export async function updatePaymentMethod(loginToken, formData) {
    const response = await requestBase.post('/api/payment_method/update', formData, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
            'Content-Type': 'multipart/form-data',
        }
    })
    return response
}

// request delete payment method
export async function deletePaymentMethod(loginToken, id) {
    const response = await requestBase.delete(`/api/payment_method?id=${id}`, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

export async function getPaymentMethodInfo(loginToken, id) {

    // 构建请求的基础 URL
    let requestUrl = `/api/payment_method?id=${id}`;

    const response = await requestBase.get(requestUrl, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request update payment method
export async function setDefault(loginToken, data) {
    const response = await requestBase.post('/api/payment_method/default', data, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}