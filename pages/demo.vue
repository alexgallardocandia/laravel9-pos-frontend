<template>
  <div>
    <Loader :load="load"></Loader>
    <AdminTemplate>
      <div slot="body">
        <div class="row justify-content-end">
          <div class="col-2">
            <button type="button" class="btn btn-dark btn-sm w-100">
              <i class="fas fa-plus"></i> Agregar
            </button>
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
                          <button type="button" class="btn btn-info btn-sm py-1 px-2">
                            <i class="fas fa-pen"></i>
                          </button>
                          <button type="button" class="btn btn-danger btn-sm py-1 px-2">
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
  name: 'demo',
  head() {
    return {
      title: "Demo"
    }
  },
  data() {
    return{
      load:true,
      list:[]
    }
  },
  methods:{
    async GET_DATA(path) {
      const res = await this.$api.$get(path)
      return res
    }
  },
  mounted(){
    this.$nextTick(async() =>{
      try {
        await Promise.all([this.GET_DATA('marcas')]).then((v)=>{
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
