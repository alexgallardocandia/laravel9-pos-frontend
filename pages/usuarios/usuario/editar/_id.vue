<template>
    <div>
      <Loader :load="load"></Loader>
      <AdminTemplate :page="page" :modulo="modulo">
        <div slot="body">
          <div class="row justify-content-center">
            <div class="col-sm-8 col-12">
              <div class="card">
                <div class="card-header">
                  <h3>Actualizar</h3> 
                </div>
                <div class="card-body">
                    <CrudUpdate :model="model" :apiUrl="apiUrl">
                      <div slot="body" class="row">
                        <div class="form-group">
                            <label for="">Username</label>
                            <input type="text" name="" v-model="model.name" class="form-control" id="">
                        </div>
                        <div class="form-group">
                            <label for="">Email</label>
                            <input type="email" name="" v-model="model.email" class="form-control" id="">
                        </div>
                        <div class="form-group">
                            <label for="">Password</label>
                            <input type="password" name="" v-model="model.password" class="form-control" id="">
                        </div>
                      </div>
                    </CrudUpdate>
                </div>
              </div>
            </div>
          </div>
        </div>
      </AdminTemplate>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Usuario',
    head() {
      return {
        title: "Usuario"
      }
    },
    data() {
      return{
        load:true,
        model:{
          name:'',
          email:'',
          password:'',
        },
        apiUrl:'users',    
        page:'Usuarios',
        modulo:'Usuario'
      }
    },
    methods:{
        async GET_DATA(path) {
            const res = await this.$api.$get(path)
            return res
        },
    },
    mounted(){
        this.$nextTick(async() =>{
            try {
                await Promise.all([this.GET_DATA(this.apiUrl+'/'+this.$route.params.id)]).then((v)=>{
                this.model = v[0]
                })
            } catch (e) {
                console.log(e);
            } finally{
                this.load = false
            }
        })
    },
  
  }
  </script>
  