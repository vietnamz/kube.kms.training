<template>
  <v-btn v-if="lang === 'EN'" color="blue darken-1" @click="changeLanguage('en')">
    {{ lang }}
  </v-btn>
  <v-btn v-else color="blue darken-1" @click="changeLanguage('jp')">
    {{ lang }}
  </v-btn>
</template>
<script>
export default {
    name: "TheLangSwitcher",
    props: {
        lang: {
            type: String,
            default: "EN",
        } 
    },
    methods: {
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
