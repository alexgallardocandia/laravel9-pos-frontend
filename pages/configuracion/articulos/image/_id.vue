<template>
  <div>
    <Loader :load="load"></Loader>
    <AdminTemplate :page="page" :modulo="modulo">
      <div slot="body">
        <div class="row justify-content-center">
          <div class="col-sm-4 col-12">
            <div class="card">
              <div class="card-header">
                <h3>Actualizar</h3>
              </div>
              <div class="card-body">
                <div class="form-control dropzone" id="fileDrop">
                  <div class="fallback">
                    <input name="file" type="file" multiple />
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-sm-8 col-12">
            <div class="card">
              <div class="card-header">
                <h3>Actualizar</h3>
              </div>
              <div class="card-body">
                <ul class="list-group">
                  <li v-for="m in model.articulo_images" class="list-group-item border-0 d-flex align-items-center px-0 mb-2">
                    <div class="avatar me-3">
                      <img :src="m.url" alt="kal" class="border-radius-lg shadow">
                    </div>
                    <a class="btn btn-link pe-3 ps-0 mb-0 ms-auto"  @click="Eliminar(m.id)">Eliminar</a>
                  </li>
                </ul>
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
  name: "IndexPage",
  head() {
    return {
      title: this.modulo,
    };
  },
  data() {
    return {
      load: true,
      model: {

      },
      apiUrl: "articuloImages/articulo",
      page: "Configuracion",
      modulo: "Articulos",

    };
  },
  methods: {
    async GET_DATA(path) {
      const res = await this.$api.$get(path);
      return res;
    },
    async EliminarItem(id){
      this.load=true
      try {
        const res = await this.$api.$post(this.apiUrl+'/delete/'+id)
        console.log(res)
        await Promise.all([this.GET_DATA(this.apiUrl+"/"+this.$route.params.id)]).then((v)=>{
          this.model = v[0]
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
  mounted() {
    this.$nextTick(async () => {
      Dropzone.autoDiscover = false;
      let self = this
      try {
        await Promise.all([
          this.GET_DATA(this.apiUrl + "/" + this.$route.params.id)
        ]).then((v) => {
          this.model = v[0];
        });
      } catch (e) {
        console.log(e);
      } finally {
        // Base URL de Axios inyectado por el plugin
        console.log(this.$api.defaults && this.$api.defaults.baseURL);
        this.load = false;
        const url = this.$api.defaults.baseURL + this.apiUrl + "/" + self.$route.params.id
        console.log(url);
        console.log(localStorage.getItem('auth_token'));
        new Dropzone('div#fileDrop', {
          url: url,
          headers: {
            'Authorization': 'Bearer ' + localStorage.getItem('auth_token'),
            'Cache-Control': null,
            'X-Requested-With': null
          }
        }).on("complete", function (file) {
          this.removeFile(file);
          Promise.all([
            self.GET_DATA(self.apiUrl + "/" + self.$route.params.id)
          ]).then((v) => {
            self.model = v[0];
          });
        });
      }
    });
  },
};
</script>
