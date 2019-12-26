import firebase from "firebase";
export default {
    initAuthentication ({dispatch}) {
        return new Promise((resolve) => {
            // TODO: unsubscribe observer if already listening
            firebase.auth().onAuthStateChanged(user => {
                if (user) {
                    dispatch("fetchAuthUser")
                        .then(dbUser => resolve(dbUser));
                } else {
                    resolve(null);
                }
            });
        });
    },

    registerUserWithEmailAndPassword ({dispatch}, {email, password}) {
        return firebase.auth().createUserWithEmailAndPassword(email, password)
            .then(data => {
                const user = data.user;
                return dispatch("users/createUser", {firebase_uid: user.uid, email}, {root: true});
            })
            .then(() => dispatch("fetchAuthUser"));
    },

    signInWithEmailAndPassword ({dispatch}, {email, password}) {
        return firebase.auth().signInWithEmailAndPassword(email, password)
            .then(()=> dispatch("fetchAuthUser"));
    },
    
    signInWithExternal ( {dispatch}, providerType) {
        // REVIEW: error prone.
        let provider = null;
        if (providerType === "google") {
            provider = new firebase.auth.GoogleAuthProvider();
        } else if (providerType === "facebook") {
            provider = new firebase.auth.FacebookAuthProvider();
        } else if (providerType === "github") {
            provider = new firebase.auth.GithubAuthProvider();
        } else {
            provider = new firebase.auth.TwitterAuthProvider();
        }
        return firebase.auth().signInWithPopup(provider)
            .then(data => {
                const user = data.user;
                const firebase_uid = user.uid;
                const email = user.email;
                this.$axios.get(`/users/v1/${firebase_uid}`)
                    .catch(() => {
                        return dispatch("users/createUser", {firebase_uid: user.uid, email}, {root: true});
                    })
                    .then(() => dispatch("fetchAuthUser"));
            });
    },

    signOut ({commit}) {
        return firebase.auth().signOut()
            .then(() => {
                commit("setAuthId", null);
            });
    },

    fetchAuthUser ({dispatch, commit}) {
        const firebase_uid = firebase.auth().currentUser.uid;
        return new Promise((resolve) => {
            this.$axios.get(`/users/v1/${firebase_uid}`)
                .then( response => {
                    if (response.statusText === "OK") {
                        const userId = response.data.user.schema.user_id;
                        return dispatch("users/fetchUser", {id: userId}, {root: true})
                            .then((user) => {
                                commit("setAuthId", userId);
                                resolve(user);
                            });
                    } else {
                        resolve(null);
                    };
                });
        });
    },
    
    resetPassword ({commit}, email) {
        console.log("resetPassword");
        console.log(email);
        return firebase.auth().sendPasswordResetEmail(email)
            .then(() => {
                commit("setAuthId", null);
            });
    }
};
