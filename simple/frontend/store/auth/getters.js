export default {
    authUser (state, getters, rootState) {
        return state.authId ? rootState.users.items[state.authId] : null;
    }
};
