export default function ({store}) {
    // If the user is not authenticated
    store.dispatch("auth/initAuthentication")
        .then(() => {
            //redirect(route.path);
        });
};
