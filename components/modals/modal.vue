<template>
    <div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content"></div>
            <Loader :load="load"></Loader>

            <div class="row">
                <div class="col-12">
                    <slot name="body">
                    
                    </slot>
                </div>
                <div class="col-12">
                    <div class="row">
                        <div class="col-6">
                            <button class="btn btn-dark w-100" @click="Save()"> Guardar</button>
                        </div>
                        <div class="col-6">
                            <button class="btn btn-info w-100" @click="$router.back()"> Regresar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>    
    
  </template>
  
  <script>
  export default {
    props:{
        model:{
            type:Object,
            default:()=>{}
        },
        apiUrl:{
            type:String,
            default:''
        }
    },
    data() {
    return{
      load:false,
    }
  },
    methods:{
      async Save() {
        this.load = true
        try {
          const res = await this.$api.$post(this.apiUrl, this.model)
          console.log(res)
          this.$swal.fire({
              title: "Guardado!",
              showDenyButton: false,
              showCancelButton: false,
          }).then((result) => {
              if (result.isConfirmed) {
                this.$router.back()
              }
          });
        } catch (e) {
          console.log(e)
        }finally{
          this.load = false
        }
      }
    },
    mounted(){
      this.$nextTick(async() =>{
        try {
          
        } catch (e) {
          console.log(e);
        } finally{
          
        }
      })
    },
  
  }
  </script>
  