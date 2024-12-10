export default function ({ $axios }, inject) {
    // Create a custom axios instance
    const api = $axios.create({
      headers: {
        common: {
          Accept: 'text/plain, */*'
        }
      }
    })
    let url = 'http://localhost/curso-pos/laravel9-pos/public/api/'
    api.url = url
    // Set baseURL to something different
    api.setBaseURL(url)
  
    // Inject to context as $api
    inject('api', api)
  }
  