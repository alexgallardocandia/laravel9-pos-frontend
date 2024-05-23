export default function ({ $axios }, inject) {
    // Create a custom axios instance
    const printer = $axios.create({
      headers: {
        common: {
          Accept: 'text/plain, */*'
        }
      }
    })
  
    // Set baseURL to something different
    // printer.setBaseURL('http://localhost/curso-pos/laravel9-pos/public/printer/')
  
    // Inject to context as $printer
    inject('printer', printer)
  }
  