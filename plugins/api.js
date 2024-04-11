export default function ({ $axios }, inject) {
    // Create a custom axios instance
    const api = $axios.create({
      headers: {
        common: {
          Accept: 'text/plain, */*'
        }
      }
    })
  
    // Set baseURL to something different
    api.setBaseURL('http://localhost/curso-pos/laravel9-pos/public/api/')
  
    // Inject to context as $api
    inject('api', api)
  }
  