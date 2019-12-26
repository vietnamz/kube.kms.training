<template>
  <div id="core-menu">
    <v-card
      v-for="item in items"
      :key="item.title"
      class="pa-1 ma-2 rounded-card"
    >
      <v-layout align-center>
        <v-flex fill-height>
          <div class="font-weight-light white--text">
            {{ $t(item.title) }}
          </div>
        </v-flex>
        <v-flex xs2 fill-height>
          <v-btn icon>
            <v-icon>mdi-plus-circle-outline</v-icon>
          </v-btn>
        </v-flex>
      </v-layout>
    </v-card>
  </div>
</template>

<script>
export default {
    name: "AppMenu",
    data () {
        return {
            items: [
                {
                    action: "/showcase",
                    title: "GroupMenuShowcases"
                },
                {
                    action: "/project",
                    title: "GroupMenuProjects",
                },
                {
                    action: "/data",
                    title: "GroupMenuData",
                },
                {
                    action: "/preprocessing",
                    title: "GroupMenuPreprocesing",
                },
                {
                    action: "/models",
                    title: "GroupMenuModels",
                },
                {
                    action: "/visualization",
                    title: "GroupMenuVisualization",
                },
                {
                    action: "/flows",
                    title: "GroupMenuProcessFlows",
                }
            ]
        };
    }
};
</script>

<style lang="scss">
  .rounded-card {
      border-radius:40px;
      background: rgba(86,86,86,1.0)
  }
</style>