<template>
  <v-app id="neurobase">
    <!-- Application Left Toolbar -->
    <core-drawer />

    <!-- Application Header -->
    <core-header />

    <v-content>
      <v-container
        mt-0 pa-0
        fluid
        style="background: #333333;"
      >
        <v-layout
          align-space-between 
          justify-start
        >
          <v-flex xs2 offset-xs0>
            <!-- Application Menu -->
            <core-menu />
          </v-flex>
          <v-flex style="background: #434343;">
            <!-- Application Main View -->
            <core-view />
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>

    <!-- Application Footer -->
    <core-footer />
  </v-app>
</template>

<script>
import coreDrawer from "~/components/core/AppDrawer";
import coreHeader from "~/components/core/AppHeader";
import coreMenu from "~/components/core/AppMenu";
import coreView from "~/components/core/AppView";
import coreFooter from "~/components/core/AppFooter";

export default {
    components: {
        coreDrawer,
        coreHeader,
        coreMenu,
        coreView,
        coreFooter
    }
};
</script>
