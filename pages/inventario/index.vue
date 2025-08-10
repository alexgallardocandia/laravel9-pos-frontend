<template>
  <div>
    <Loader :load="load"></Loader>
    <AdminTemplate :page="page" :modulo="modulo">
      <div slot="body">
        <div class="row justify-content-end">
          <div class="col-2">
            
          </div>
          <div class="col-12">
            <!-- Buscador -->
            <div class="card mb-3">
              <div class="card-body">
                <div class="row">
                  <div class="col-md-6">
                    <div class="input-group">
                      <span class="input-group-text">
                        <i class="fas fa-search"></i>
                      </span>
                      <input 
                        type="text" 
                        class="form-control" 
                        placeholder="Buscar por nombre, código, marca o categoría..."
                        v-model="searchTerm"
                        @input="filterInventory"
                      >
                    </div>
                  </div>
                  <div class="col-md-3">
                    <button 
                      class="btn btn-secondary" 
                      @click="clearSearch"
                      :disabled="!searchTerm"
                    >
                      <i class="fas fa-times"></i> Limpiar
                    </button>
                  </div>
                  <div class="col-md-3 text-end">
                    <span class="badge bg-info">
                      {{ filteredList.length }} de {{ list.length }} artículos
                    </span>
                  </div>
                </div>
              </div>
            </div>
            
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
                    <tr v-for="(m,i) in filteredList" >
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
                
                <!-- Mensaje cuando no hay resultados -->
                <div v-if="filteredList.length === 0 && searchTerm" class="text-center py-4">
                  <i class="fas fa-search fa-3x text-muted mb-3"></i>
                  <h5 class="text-muted">No se encontraron resultados</h5>
                  <p class="text-muted">Intenta con otros términos de búsqueda</p>
                </div>
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
      filteredList: [],
      searchTerm: '',
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
    
    // Método para filtrar el inventario
    filterInventory() {
      if (!this.searchTerm.trim()) {
        this.filteredList = [...this.list];
        return;
      }
      
      const searchLower = this.searchTerm.toLowerCase().trim();
      
      this.filteredList = this.list.filter(item => {
        return (
          item.nombre?.toLowerCase().includes(searchLower) ||
          item.barra?.toLowerCase().includes(searchLower) ||
          item.marca?.nombre?.toLowerCase().includes(searchLower) ||
          item.categoria?.nombre?.toLowerCase().includes(searchLower)
        );
      });
    },
    
    // Método para limpiar la búsqueda
    clearSearch() {
      this.searchTerm = '';
      this.filteredList = [...this.list];
    },
    
    async EliminarItem(id){
      this.load=true
      try {
        const res = await this.$api.$delete(this.apiUrl+'/'+id)
        console.log(res)
        await Promise.all([this.GET_DATA(this.apiUrl)]).then((v)=>{
          this.list = v[0]
          this.filteredList = [...this.list]
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
          this.filteredList = [...this.list]
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
