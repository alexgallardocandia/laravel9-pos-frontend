<template>
    <div>
      <Loader :load="load"></Loader>
      <AdminTemplate :page="page" :modulo="modulo">
        <div slot="body">
          <div class="row justify-content-end">
            <div class="col-12">
              <div class="card">
                <div class="card-body">
                  <table class="table">
                    <thead>
                      <th class="py-0 px-1">#</th>
                      <th class="py-0 px-1">Fecha</th>
                      <th class="py-0 px-1">Usuario</th>
                      <th class="py-0 px-1">Total</th>
                      <th class="py-0 px-1"></th>
                    </thead>
                    <tbody>
                      <tr v-for="(m,i) in list" >
                        <td class="py-0 px-1">{{ i+1 }}</td>
                        <td class="py-0 px-1">{{ m.fecha }}</td>
                        <td class="py-0 px-1">{{ m.user.name }}</td>
                        <td class="py-0 px-1">{{ $formatNumber(m.total) }}</td>
                        <!-- <td class="py-0 px-1">
                          <div class="btn-group">
                            <nuxtLink :to="url_editar+m.id" class="btn btn-info btn-sm py-1 px-2">
                              <i class="fas fa-eye"></i>
                            </nuxtLink>
                            <button type="button" @click="Eliminar(m.id)" class="btn btn-danger btn-sm py-1 px-2">
                              <i class="fas fa-trash"></i>
                            </button>
                            <button type="button" @click="ImprimirVenta(m)" class="btn btn-success btn-sm py-1 px-2">
                              <i class="fas fa-print"></i>
                            </button>
                          </div>
                        </td> -->
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
        sucursals:[],
        sucursal:{

        },
        apiUrl:'cajas',
        page:'Ventas',
        modulo:'Lista de Cajas',
  
      }
    },
    methods:{
      async GET_DATA(path) {
        const res = await this.$api.$get(path)
        return res
      },
      async ImprimirVenta(venta) {
            let sucursal = this.sucursal
            sucursal.venta = venta
            const res = await this.$printer.$post(sucursal.impresora_url + "venta", sucursal)
            console.log(res)
      }
  
    },
    mounted(){
      this.$nextTick(async() =>{
        try {
          await Promise.all([this.GET_DATA(this.apiUrl)]).then((v)=>{
            this.list = v[0];
            this.sucursals = v[1];
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
  