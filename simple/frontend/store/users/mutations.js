import Vue from "vue";

export default {
    setUser (state, {user, userId}) {
        Vue.set(state.items, userId, user);
    },
};
