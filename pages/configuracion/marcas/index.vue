<template>
  <div>
    <Loader :load="load"></Loader>
    <AdminTemplate :page="page" :modulo="modulo">
      <div slot="body">
        <div class="row justify-content-end">
          <div class="col-2">
            <nuxtLink :to="url_nuevo" class="btn btn-dark btn-sm w-100">
              <i class="fas fa-plus"></i> Agregar
            </nuxtLink>
            <div class="col-lg-12">
                <button
                  class="btn bg-gradient-primary mb-0 mt-lg-auto w-100"
                  type="button"
                  name="button"
                  data-bs-toggle="modal"
                  data-bs-target="#AjusteModal"
                >
                  <i class="fas fa-cog"></i>
                  Ajustar Stock
                </button>
                
              </div>
          </div>
          <div class="col-12">
            <div class="card">
              <div class="card-body">
                <table class="table">
                  <thead>
                    <th class="py-0 px-1">#</th>
                    <th class="py-0 px-1">Nombre</th>
                    <th class="py-0 px-1"></th>
                  </thead>
                  <tbody>
                    <tr v-for="(m,i) in list" >
                      <td class="py-0 px-1">{{ i+1 }}</td>
                      <td class="py-0 px-1">{{ m.nombre }}</td>
                      <td class="py-0 px-1">
                        <div class="btn-group">
                          <nuxtLink :to="url_editar+m.id" class="btn btn-info btn-sm py-1 px-2">
                            <i class="fas fa-pen"></i>
                          </nuxtLink>
                          <button type="button" @click="Eliminar(m.id)" class="btn btn-danger btn-sm py-1 px-2">
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <ModalsModal></ModalsModal>
          </div>
        </div>
      </div>
    </AdminTemplate>
  </div>
</template>

<script>
  export default {
    name: 'demo',
    head() {
      return {
        title: this.modulo
      }
    },
    data() {
      return{
        showModal: false,
        load:true,
        list:[],
        apiUrl:'marcas',
        page:'Configuracion',
        modulo:'Marcas',
        url_nuevo:'/configuracion/marcas/nuevo',
        url_editar:'/configuracion/marcas/editar/',

      }
    },
    methods:{
      async GET_DATA(path) {
        const res = await this.$api.$get(path)
        return res
      },
      async EliminarItem(id){
        this.load=true
        try {
          const res = await this.$api.$delete(this.apiUrl+'/'+id)
          console.log(res)
          await Promise.all([this.GET_DATA(this.apiUrl)]).then((v)=>{
            this.list = v[0]
          })
        } catch (e) {
          console.log(e);
        } finally{
          this.load = false
        }
        
      },
      Eliminar(id) {
        let self = this
        this.$swal.fire({
          title: "Deseas Eliminar?",
          showDenyButton: false,
          showCancelButton: true,
          confirmButtonText: "Eliminar",
          cancelarButtonText: "Cancelar"
        }).then( async (result) => {

          if (result.isConfirmed) {
            await self.EliminarItem(id)
          }
        });
      }

    },
    mounted(){
      this.$nextTick(async() =>{
        try {
          await Promise.all([this.GET_DATA(this.apiUrl)]).then((v)=>{
            this.list = v[0]
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
