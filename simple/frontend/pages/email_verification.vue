<template>
  <v-container grid-list-lg>
    <v-row row justify="center">
      <v-col xs12 class="text-center display-1 font-weight-black my-5 justify-center">
        Connectome
      </v-col>
    </v-row>
    <v-row row wrap justify="center">
      <v-col md="6" align-center>
        <v-card color="#FFFFFF" class="mt-6">
          <v-card-text class="text-center black--text py-12">
            <div class="headline mb-2 text-center">
              Your email was verified successfully
            </div>
            Thank you for using our services.
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
    layout: "password",
    data: () => ({
    }),

    methods: {
        test () {
            console.log("thanhtkkkkkkkkkkk ");
        }
    },
};
</script>

<style>

</style>
