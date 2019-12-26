
export default {
    SET_DRAWER(state, drawer) {
        state.drawer = drawer;
    },
    SET_IMAGE(state, image) {
        state.image = image;
    },
    SET_COLOR(state, color) {
        state.color = color;
    },
    setLoginState(state, hasLogin) {
        // Vue.set(state.loginState, Object.keys(hasLogin), Object.values(hasLogin));
        state.loginState = hasLogin;
    }
};
