<template>
  <div>
    <Loader :load="load"></Loader>
    <AdminTemplate :page="page" :modulo="modulo">
      <div slot="body">
        <div class="row justify-content-end">
          <div class="col-2">
            
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
                    <th class="py-0 px-1">Stock</th>
                    <th class="py-0 px-1">Inversion</th>
                    <th class="py-0 px-1">Valorizado</th>
                    <th class="py-0 px-1">Ganancia</th>
                    <th class="py-0 px-1"></th>
                  </thead>
                  <tbody>
                    <tr v-for="(m,i) in list" >
                      <td class="py-0 px-1">{{ i+1 }}</td>
                      <td class="py-0 px-1">{{ m.nombre }}</td>
                      <td class="py-0 px-1">{{ m.barra }}</td>
                      <td class="py-0 px-1">{{ m.marca.nombre }}</td>
                      <td class="py-0 px-1">{{ m.categoria.nombre }}</td>
                      <td class="py-0 px-1"> <span class="badge " :class="[m.stock <= m.stock_minimo?'badge-danger':'badge-success']">{{ m.stock }} {{ m.medida.codigo }}</span></td>
                      <td class="py-0 px-1">{{ $formatNumber(m.inversion) }}</td>
                      <td class="py-0 px-1">{{ $formatNumber(m.valorizado)}}</td>
                      <td class="py-0 px-1">{{ $formatNumber(m.ganancia)}}</td>
                      <td class="py-0 px-1">
                        <div class="btn-group">
                          <nuxtLink :to="url_editar+m.id" class="btn btn-info btn-sm py-1 px-2">
                            <i class="fas fa-eye"></i>
                          </nuxtLink>
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
      apiUrl:'inventario',
      page:'Inventario',
      modulo:'General',
      url_editar:'/inventario/kardex/',

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
