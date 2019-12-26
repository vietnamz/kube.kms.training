<template>
  <div id="app" class="container">
    <div v-if="sent">
      <v-row justify="center">
        <p> {{ $t("EmailResetConfirmation") }}</p>
      </v-row>
      <v-row justify="center">
        <nuxt-link to="/">
          {{ $t("Home") }}
        </nuxt-link>
      </v-row>
    </div>
    <div v-else class="row justify-content-center mt-12">
      <template>
        <div class="col-xs-3 col-sm-3 col-md-3" />
        <div class="col-xs-6 col-sm-6 col-md-6">
          <h1 class="text-center">
            {{ $t("ResetPassword") }}
          </h1>
          <v-form>
            <v-text-field
              v-model.lazy="form.email"
              label="E-mail"
              required
              @blur="$v.form.email.$touch()"
            />
            <template v-if="$v.form.email.$error">
              <span v-if="!$v.form.email.required">{{ $t("FieldRequired") }}</span>
              <span v-else-if="!$v.form.email.email">{{ $t("NotValidEmail") }}</span>
              <!--              <span v-else-if="!$v.form.email.notExist">{{ $t("EmailNotExist") }}</span>-->
            </template>
            <v-layout justify-center>
              <v-card-actions>
                <v-btn
                  @click="reset"
                >
                  {{ $t("ResetPasswordButton") }}
                </v-btn>
              </v-card-actions>
            </v-layout>
          </v-form>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import {required, email} from "vuelidate/lib/validators";
import {emailNotExist} from "@/utils/validators";
export default {
    layout: "password",
    data: () => ({
        form: {
        	email: "",
        },
        sent: false
    }),
    validations: {
        form: {
            email: {
                required,
                email,
                notExist: emailNotExist
            },
        }
    },
    methods: {
    	reset() {

    		this.$store.dispatch("auth/resetPassword", this.form.email)
                .then( () => {
                    this.$toast.success("A email has been sent to you. Please check email to reset your password",
                        {"duration" : 3000});
                	// this.sent = true;
                    this.$router.push("/");
                })
                .catch( () => {
                    this.$toast.error("This email wasn't registered yet. Please check again",
                        {"duration" : 4000});
                });
        },
    },
};
</script>
