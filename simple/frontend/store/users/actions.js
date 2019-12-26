
export default {
    createUser ({state, commit}, {firebase_uid, email}) {
        return new Promise((resolve) => {
            // const registeredAt = Math.floor(Date.now() / 1000)
            email = email.toLowerCase();
            // const user = {firebase_uid, email};
            // Send token to your backend via HTTP
            // ...
            const formData = new FormData();
            formData.append("email", email);
            formData.append("firebase_uid", firebase_uid);
            this.$axios.post("/users/v1", formData)
                .then( response => {
                    const user = response.data.user.schema;
                    const userId = user.user_id;
                    commit("setItem", {resource: "users", userId, user}, {root: true});
                    resolve(state.items[userId]);
                })
                .catch(error => {
                    console.log(error.message);
                });
        });
    },
    fetchUser: ({dispatch}, {id}) => dispatch("fetchItem", {resource: "users", id}, {root: true}),
};
