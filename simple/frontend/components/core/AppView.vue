<template>
  <div id="core-view">
    <v-fade-transition mode="out-in">
      <nuxt />
    </v-fade-transition>
  </div>
</template>

<script>
export default {
    name: "AppView"
};
</script>

<style>
  #core-view {
    padding-bottom: 100px;
    background: rgba(67, 67, 67, 1);
  }
</style>