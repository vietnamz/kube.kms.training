<template>
  <v-app-bar
    id="core-header"
    flat
    app
    dense
  >
    <v-toolbar-title>
      <!-- TODO: context navigation links -->
      {{ title }}
    </v-toolbar-title>
    <div class="flex-grow-1" />
    <v-text-field
      v-if="responsiveInput"
      small
      append-icon="mdi-magnify"
      hide-details
      single-line
      clearable
    />
    <v-spacer />
    <TheLangSwitcher lang="EN" />
    <TheLangSwitcher lang="JP" />
    <template v-if="!authUser">
      <loginDialog />
      <registrationDialog />
    </template>
    <UserProfile v-else />
  </v-app-bar>
</template>

<script>
import TheLangSwitcher from "~/components/TheLangSwitcher";
import registrationDialog from "~/components/dialog/RegistrationDialog";
import loginDialog from "~/components/dialog/LoginDialog";
import UserProfile from "../menu/UserProfile";
import {mapGetters} from "vuex";
export default {
    name: "AppHeader",
    components: {
        loginDialog,
        registrationDialog,
        TheLangSwitcher,
	    UserProfile
    },
    data: () => ({
        title: "TODO: breadcrumbs-content",
        responsive: true,
        responsiveInput: true,
        items: ["English", "日本人"]
    }),
    computed: {
    	...mapGetters({
            authUser: "auth/authUser"
    	}),
    },
    mounted () {
        this.onResponsiveInverted();
        window.addEventListener("resize", this.onResponsiveInverted);
    },
    beforeDestroy () {
        window.removeEventListener("resize", this.onResponsiveInverted);
    },
    methods: {
        onResponsiveInverted () {
            if (window.innerWidth < 991) {
                this.responsive = true;
                this.responsiveInput = false;
            } else {
                this.responsive = false;
                this.responsiveInput = true;
            }
        },
        /**
         * Called when a language button is clicked
         * Changes the i18n context variable's locale to the one selected
         */
        changeLanguage(lang) {
            this.$i18n.locale = lang;
        },
    }
};
</script>

<style>
  #core-header {
    background-color: rgba(33, 33, 33, 1);
  }
  #core-header a {
    text-decoration: none;
  }
</style>
