import * as firebase from "firebase/app";
import "firebase/auth";

const firebaseConfig = {
    apiKey: process.env.firebaseClientApiKey,
    authDomain: process.env.firebaseClientAuthDomain,
    databaseURL: process.env.firebaseClientDatabaseUrl,
    messagingSenderId: process.env.firebaseClientMessagingSenderId,
    projectId: process.env.firebaseClientProjectId,
    storageBucket: process.env.firebaseClientStorageBucket,
    appId: process.env.firebaseClientAppId
};

export default (!firebase.apps.length
    ? firebase.initializeApp(firebaseConfig)
    : firebase.app());

export const firebaseAuth = firebase.auth();
export const googleProvider = new firebase.auth.GoogleAuthProvider();
export const facebookProvider = new firebase.auth.FacebookAuthProvider();
export const githubProvider = new firebase.auth.GithubAuthProvider();
