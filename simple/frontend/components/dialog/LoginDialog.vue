<template>
  <v-dialog :value.sync="dialog" persistent max-width="400px">
    <template v-slot:activator="{ on }">
      <v-btn
        small
        exact
        ma-2
        class="grey lighten-1 black--text"
        v-on="on"
        @click="switchDialog(true)"
      >
        {{ $t("SignIn") }}
      </v-btn>
    </template>
    <v-card>
      <v-card-title>
        <v-row>
          <appLogo class="offset-1" />
        </v-row>
        <v-row> {{ $t("SignIn") }} </v-row>
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
            <span v-else-if="!$v.form.email.notExist">{{ $t("EmailNotExist") }}</span>
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
          <v-btn small text @click="signInWithExternal('google')">
            <v-icon color="blue darken-1" small>
              mdi-google
            </v-icon>
            {{ $t('LoginWithGoogle') }}
          </v-btn>
          <v-btn small text @click="signInWithExternal('github')">
            <v-icon color="blue darken-1" small>
              mdi-github-box
            </v-icon>
            {{ $t('LoginWithGithub') }}
          </v-btn>
        </v-col>
      </v-card-text>
      <v-card-actions>
        <nuxt-link to="/password_reset">
          {{ $t("ForgetPassword") }}
        </nuxt-link>
        <div class="flex-grow-1" />
        <v-btn color="blue darken-1" text @click="switchDialog(false)">
          {{ $t("Close") }}
        </v-btn>
        <v-btn color="blue darken-1" text @click="signIn">
          {{ $t("SignIn") }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import appLogo from "~/components/core/AppLogo";
import {required, email, minLength} from "vuelidate/lib/validators";
import {emailNotExist} from "@/utils/validators";

export default {
    name: "LoginDialog",
    components: {
        appLogo
    },
    data () {
        return {
        	form: {
		        email: "",
		        password: "",
	        }
        };
    },
    validations: {
        form: {
            email: {
                required,
                email,
                notExist: emailNotExist
            },
            password: {
                required,
                minLength: minLength(6)
            },
        }
    },
    computed: {
        dialog () {
            return this.$store.getters["app/getLoginState"].hasLogin;
        }
    },
    methods: {
        switchDialog (state) {
            this.$store.dispatch("app/setLoginState", {hasLogin: state});
        },
        signIn() {
	        this.$v.form.$touch();
	        if (this.$v.form.$invalid) {
		        return;
	        }
        	this.$store.dispatch("auth/signInWithEmailAndPassword", {email: this.email, password: this.password})
                .then(() => {
                	this.redirectToDashboard();
                });
        },
	    signInWithExternal(provider) {
		    this.$store.dispatch("auth/signInWithExternal", provider)
			    .then(() => {
			    	this.redirectToDashboard();
			    });
	    },
        redirectToDashboard() {
	        this.switchDialog(false);
	        this.$router.push("dashboard");
        }
    }
};
</script>
