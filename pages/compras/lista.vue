<template>
    <div>
      <Loader :load="load"></Loader>
      <AdminTemplate :page="page" :modulo="modulo">
        <div slot="body">
          <div class="row justify-content-end">
            <div class="col-12">
              <!-- Filtros de búsqueda -->
              <div class="card mb-3">
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-3">
                      <label class="form-label">Fecha desde:</label>
                      <input 
                        type="date" 
                        class="form-control" 
                        v-model="filters.fechaDesde"
                        @change="filterCompras"
                      >
                    </div>
                    <div class="col-md-3">
                      <label class="form-label">Fecha hasta:</label>
                      <input 
                        type="date" 
                        class="form-control" 
                        v-model="filters.fechaHasta"
                        @change="filterCompras"
                      >
                    </div>
                    <div class="col-md-3">
                      <label class="form-label">Proveedor:</label>
                      <input 
                        type="text" 
                        class="form-control" 
                        placeholder="Buscar por proveedor..."
                        v-model="filters.proveedor"
                        @input="filterCompras"
                      >
                    </div>
                    <div class="col-md-3">
                      <label class="form-label">&nbsp;</label>
                      <div class="d-grid">
                        <button 
                          class="btn btn-secondary" 
                          @click="clearFilters"
                          :disabled="!hasActiveFilters"
                        >
                          <i class="fas fa-times"></i> Limpiar Filtros
                        </button>
                      </div>
                    </div>
                  </div>
                  <div class="row mt-2">
                    <div class="col-12 text-end">
                      <span class="badge bg-info">
                        {{ filteredList.length }} de {{ list.length }} compras
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
                      <th class="py-0 px-1">Fecha</th>
                      <th class="py-0 px-1">Proveedor</th>
                      <th class="py-0 px-1">Total</th>
                      <th class="py-0 px-1"></th>
                    </thead>
                    <tbody>
                      <tr v-for="(m,i) in filteredList" >
                        <td class="py-0 px-1">{{ i+1 }}</td>
                        <td class="py-0 px-1">{{ m.fecha }}</td>
                        <td class="py-0 px-1">{{ m.proveedor }}</td>
                        <td class="py-0 px-1">{{ $formatNumber(m.total) }}</td>
                        <td class="py-0 px-1">
                          <div class="btn-group">
                            <nuxtLink :to="url_editar+m.id" class="btn btn-info btn-sm py-1 px-2">
                              <i class="fas fa-eye"></i>
                            </nuxtLink>
                            <button type="button" @click="Eliminar(m.id)" class="btn btn-danger btn-sm py-1 px-2">
                              <i class="fas fa-trash"></i>
                            </button>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  
                  <!-- Mensaje cuando no hay resultados -->
                  <div v-if="filteredList.length === 0 && hasActiveFilters" class="text-center py-4">
                    <i class="fas fa-search fa-3x text-muted mb-3"></i>
                    <h5 class="text-muted">No se encontraron resultados</h5>
                    <p class="text-muted">Intenta con otros filtros de búsqueda</p>
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
        filters: {
          fechaDesde: '',
          fechaHasta: '',
          proveedor: ''
        },
        apiUrl:'compras',
        page:'Configuracion',
        modulo:'Lista de Compras',
        url_editar:'/compras/invoice/',
  
      }
    },
    computed: {
      hasActiveFilters() {
        return this.filters.fechaDesde || this.filters.fechaHasta || this.filters.proveedor.trim();
      }
    },
    methods:{
      async GET_DATA(path) {
        const res = await this.$api.$get(path)
        return res
      },
      
      // Método para filtrar las compras
      filterCompras() {
        this.filteredList = this.list.filter(compra => {
          let matchFechaDesde = true;
          let matchFechaHasta = true;
          let matchProveedor = true;
          
          // Filtro por fecha desde
          if (this.filters.fechaDesde) {
            const fechaCompra = new Date(compra.fecha);
            const fechaDesde = new Date(this.filters.fechaDesde);
            matchFechaDesde = fechaCompra >= fechaDesde;
          }
          
          // Filtro por fecha hasta
          if (this.filters.fechaHasta) {
            const fechaCompra = new Date(compra.fecha);
            const fechaHasta = new Date(this.filters.fechaHasta);
            matchFechaHasta = fechaCompra <= fechaHasta;
          }
          
          // Filtro por proveedor
          if (this.filters.proveedor.trim()) {
            const proveedorLower = this.filters.proveedor.toLowerCase().trim();
            matchProveedor = compra.proveedor.toLowerCase().includes(proveedorLower);
          }
          
          return matchFechaDesde && matchFechaHasta && matchProveedor;
        });
      },
      
      // Método para limpiar todos los filtros
      clearFilters() {
        this.filters = {
          fechaDesde: '',
          fechaHasta: '',
          proveedor: ''
        };
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
  