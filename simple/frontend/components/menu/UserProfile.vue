<template>
  <div class="text-center">
    <v-menu offset-y>
      <template v-slot:activator="{ on }">
        <v-btn fab icon v-on="on">
          <v-avatar
            :size="avaSize"
          >
            <img
              :src="userAvatar"
              alt="avatar"
            >
          </v-avatar>
        </v-btn>
      </template>
      <v-list>
        <v-list-item
          v-for="(item, index) in items"
          :key="index"
          @click="signOut"
        >
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
  </div>
</template>

<script>
import {mapGetters} from "vuex";
export default {
    name: "SignOut",
    data: () => ({
        avaSize: 45,
        defaultImg: "http://i.imgur.com/6MuObMP.jpg",
        items: [
            { title: "Sign Out" },
        ],
    }),
    computed: {
	    ...mapGetters({
		    authUser: "auth/authUser"
	    }),
        userAvatar () {
	        if (this.authUser) {
                console.log(this.authUser);
	        	if (this.authUser.photo_1) {
			        return this.authUser.photo_1;
                } else {
	        		return this.defaultImg;
		        }
	        } else {
	        	return this.defaultImg;
            }
        }
    },
    methods: {
        signOut () {
	        this.$store.dispatch("auth/signOut");
	        this.$router.push("/");
        }
    }
};
</script>

<style scoped>

</style>
