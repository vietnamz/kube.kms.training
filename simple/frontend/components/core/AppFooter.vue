<template>
  <v-footer
    id="core-footer"
    app
  >
    <div>
      <!-- Footer links if any -->
    </div>
    <v-spacer />
    <span class="px-4">
      &copy; Copyright
      {{ (new Date()).getFullYear() }} Inc.
    </span>
  </v-footer>
</template>

<script>
export default {
    name: "AppFooter"
};
</script>

<style>
  #core-footer {
    background-color: rgba(33, 33, 33, 1);
  }
</style>