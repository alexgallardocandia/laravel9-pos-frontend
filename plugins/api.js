export default function ({ $axios }, inject) {
  const api = $axios.create({
    headers: {
      common: {
        Accept: 'application/json', // mejor que text/plain
      },
    },
  })

  const url = 'http://localhost:8000/api/'
  api.setBaseURL(url)

  // Agregar interceptor para agregar token en cada petición
  api.onRequest(config => {
    const token = localStorage.getItem('auth_token')
    if (token) {
      config.headers.common['Authorization'] = `Bearer ${token}`
    }
    return config
  })

  inject('api', api)
}
