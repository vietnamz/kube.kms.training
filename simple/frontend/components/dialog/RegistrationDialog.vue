<template>
  <v-dialog v-model="dialog" persistent max-width="600px">
    <template v-slot:activator="{ on }">
      <v-btn
        small
        exact
        class="grey lighten-1 black--text"
        v-on="on"
      >
        {{ $t("Register") }}
      </v-btn>
    </template>
    <v-card>
      <v-card-title>
        <v-row>
          <v-col cols="5">
            <appLogo />
          </v-col>
          <v-col cols="6">
            {{ $t("Register") }}
          </v-col>
        </v-row>
      </v-card-title>
      <v-card-text>
        <v-col cols="12">
          <v-text-field
            v-model.lazy="form.email"
            :label="$t('Email')"
            required
            @blur="$v.form.email.$touch()"
          />
          <template v-if="$v.form.email.$error">
            <span v-if="!$v.form.email.required">{{ $t("FieldRequired") }}</span>
            <span v-else-if="!$v.form.email.email">{{ $t("NotValidEmail") }}</span>
            <span v-else-if="!$v.form.email.unique">{{ $t("EmailTaken") }}</span>
          </template>
        </v-col>
        <v-col cols="12">
          <v-text-field
            v-model.lazy="form.password"
            :label="$t('Password')"
            type="password"
            required
            @blur="$v.form.password.$touch()"
          />
          <template v-if="$v.form.password.$error">
            <span v-if="!$v.form.password.required">{{ $t("FieldRequired") }}</span>
            <span v-else-if="!$v.form.password.minLength">
              {{ $t("MinPassword") }}
            </span>
          </template>
        </v-col>
        <v-col cols="12">
          <v-text-field
            v-model.lazy="form.passwordRepeat"
            :label="$t('PasswordRepeat')"
            type="password"
            required
            @blur="$v.form.passwordRepeat.$touch()"
          />
          <template v-if="$v.form.passwordRepeat.$error">
            <span v-if="!$v.form.passwordRepeat.required">{{ $t("FieldRequired") }}</span>
            <span v-else-if="!$v.form.passwordRepeat.sameAsPassword">
              {{ $t("PasswordIdentical") }}
            </span>
          </template>
        </v-col>
      </v-card-text>
      <v-card-actions>
        <v-btn color="blue darken-1" text @click="switchToLogin">
          {{ $t("AlreadyHaveAccount") }}
        </v-btn>
        <div class="flex-grow-1" />
        <v-btn color="blue darken-1" text @click="dialog = false">
          {{ $t("Close") }}
        </v-btn>
        <v-btn color="blue darken-1" text @click="register">
          {{ $t("Register") }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import appLogo from "~/components/core/AppLogo";
import {required, email, minLength, sameAs} from "vuelidate/lib/validators";
import {uniqueEmail} from "@/utils/validators";

export default {
    name: "RegistrationDialog",
    components: {
        appLogo
    },
    data () {
    	return {
		    dialog: false,
		    form: {
			    email: "",
			    password: "",
			    passwordRepeat: ""
		    }
	    };
    },
    validations: {
    	form: {
    		email: {
    			required,
                email,
                unique: uniqueEmail
            },
            password: {
	            required,
	            minLength: minLength(6)
            },
		    passwordRepeat: {
    			required,
			    sameAsPassword: sameAs("password")
            }
        }
    },
    methods: {
        switchToLogin () {
            this.$store.dispatch("app/setLoginState", {hasLogin: true});
            this.dialog = false;
        },
        register () {
	        this.$v.form.$touch();
	        if (this.$v.form.$invalid) {
		        return;
	        }
            this.$store.dispatch("auth/registerUserWithEmailAndPassword", this.form)
                .then (() => {
                	  this.$router.push("dashboard");
                	  this.dialog = false;
                });
        }
    }
};
</script>

<style scoped>

</style>
