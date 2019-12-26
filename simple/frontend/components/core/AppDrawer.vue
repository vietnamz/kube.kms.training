<template>
  <v-navigation-drawer
    id="core-drawer"
    v-model="inputValue"
    app
    dark
    fixed
    persistent
    mobile-break-point="991"
    width="48"
  >
    <v-layout
      align-start
      justify-start
      column
    >
      <v-list dense
              max-width="48"
              max-height="48"
      >
        <v-list-item
          dense
        >
          <v-list-item-avatar
            left
            height="48"
            max-width="48"
            max-height="48"
          >
            <appLogo />
          </v-list-item-avatar>
        </v-list-item>
      </v-list>
      <v-divider />
      <v-list dense>
        <v-list-item
          v-for="(link, i) in links"
          :key="i"
          :to="link.to"

          :class="link.to === $route.path ? 'highlighted' : 'v-list-item'"
          dense
          max-width="48"
          max-height="48"
        >
          <v-list-item-action>
            <v-icon>{{ link.icon }}</v-icon>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </v-layout>
  </v-navigation-drawer>
</template>

<script>
// Utilities
import { mapActions, mapGetters } from "vuex";
import appLogo from "~/components/core/AppLogo";

export default {
    name: "AppDrawer",
    components: {
        appLogo
    },
    data() {
        return {
            links: [
                {
                    to: "/",
                    icon: "mdi-home-circle",
                    text: "Home"
                },
                /*                 {
                    to: "/lab",
                    icon: "mdi-factory",
                    text: "Lab"
                },
 */                {
                    to: "/new",
                    icon: "mdi-plus-box",
                    text: "New"
                }
            ],
            responsive: true
        };
    },
    computed: {
        ...mapGetters({
            color: "app/getColor",
            drawer: "app/getDrawer"
        }),


        inputValue: {
            get() {
                return this.drawer;
            },
            set(val) {
                this.setDrawer(val);
            }
        }
    },
    mounted () {
        this.onResponsiveInverted();
        window.addEventListener("resize", this.onResponsiveInverted);
    },
    beforeDestroy () {
        window.removeEventListener("resize", this.onResponsiveInverted);
    },
    methods: {
        ...mapActions({
            setDrawer: "app/setDrawer"
        }),

        onResponsiveInverted() {
            this.responsive = window.innerWidth < 991;
        }
    }
};
</script>

<style lang="scss">
  #core-drawer {
    background-color: rgba(33, 33, 33, 1);

    &.v-navigation-drawer .v-list {
      background: rgba(33, 33, 33, 1);
      padding: 0;
    }

    .v-divider {
      margin: 0;
    }

    .v-list__item {
      border-radius: 2px;
    }
  }
</style>
