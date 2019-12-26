<template>
  <div id="dekRankingCard">
    <v-layout align-center>
      <v-flex xs2 fill-height>
        <v-icon>{{ icon }}</v-icon>
      </v-flex>
      <v-flex fill-height>
        <div class="black--text">
          {{ order }} {{ name }}
        </div>
        <div class="grey--text">
          {{ desc }}
        </div>
      </v-flex>
      <v-flex xs3 fill-height>
        <v-btn v-if="isPaid === true" depressed small disabled>
          {{ fee }}
        </v-btn>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
export default {
    name: "DekRankingCard",
    props: {
        icon: {
            type: String,
            default: "EN"
        },
        order: {
            type: Number,
            default: 0
        },
        name: {
            type: String,
            default: ""
        },
        desc: {
            type: String,
            default: ""
        },
        isPaid: {
            type: Boolean,
            default: true
        },
        fee: {
            type: Number,
            default: 0
        },
    }
};
</script>

<style lang="scss">
</style>