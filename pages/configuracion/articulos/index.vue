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
          </div>
          <div class="col-12">
            <div class="card">
              <div class="card-body">
                <table class="table">
                  <thead>
                    <th class="py-0 px-1">#</th>
                    <th class="py-0 px-1">Nombre</th>
                    <th class="py-0 px-1">CodeBar</th>
                    <th class="py-0 px-1">Marca</th>
                    <th class="py-0 px-1">Categoria</th>
                    <th class="py-0 px-1">Stock Min</th>
                    <th class="py-0 px-1">P. Compra</th>
                    <th class="py-0 px-1">P. Venta</th>
                    <th class="py-0 px-1"></th>
                  </thead>
                  <tbody>
                    <tr v-for="(m,i) in list" >
                      <td class="py-0 px-1">{{ i+1 }}</td>
                      <td class="py-0 px-1">{{ m.nombre }}</td>
                      <td class="py-0 px-1">{{ m.barra }}</td>
                      <td class="py-0 px-1">{{ m.marca.nombre }}</td>
                      <td class="py-0 px-1">{{ m.categoria.nombre }}</td>
                      <td class="py-0 px-1">{{ m.stock_minimo }} {{ m.medida.codigo }}</td>
                      <td class="py-0 px-1">{{ m.compra }}</td>
                      <td class="py-0 px-1">{{ m.venta }}</td>
                      <td class="py-0 px-1">
                        <div class="btn-group">
                          <nuxtLink :to="url_editar+m.id" class="btn btn-info btn-sm py-1 px-2">
                            <i class="fas fa-pen"></i>
                          </nuxtLink>
                          <nuxtLink :to="url_image+m.id" class="btn btn-success btn-sm py-1 px-2">
                            <i class="fas fa-image"></i>
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
          </div>
        </div>
      </div>
    </AdminTemplate>
  </div>
</template>

<script>
export default {
  head() {
    return {
      title: this.modulo
    }
  },
  data() {
    return{
      load:true,
      list:[],
      apiUrl:'articulos',
      page:'Configuracion',
      modulo:'Articulos',
      url_nuevo:'/configuracion/articulos/nuevo',
      url_editar:'/configuracion/articulos/editar/',
      url_image:'/configuracion/articulos/image/',

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
