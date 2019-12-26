import colors from "vuetify/es5/util/colors";
require("dotenv").config();

export default {
    mode: "spa",
    /**
     * Environment variables
     */
    env: {
        firebaseClientApiKey: process.env.FIREBASE_CLIENT_API_KEY,
        firebaseClientAuthDomain: process.env.FIREBASE_CLIENT_AUTH_DOMAIN,
        firebaseClientDatabaseUrl: process.env.FIREBASE_CLIENT_DATABASE_URL,
        firebaseClientMessagingSenderId: process.env.FIREBASE_CLIENT_MESSAGING_SENDER_ID,
        firebaseClientProjectId: process.env.FIREBASE_CLIENT_PROJECT_ID,
        firebaseClientStorageBucket: process.env.FIREBASE_CLIENT_STORAGE_BUCKET,
        firebaseClientAppId: process.env.FIREBASE_CLIENT_APP_ID
    },
    /**
     * Headers of the page
     */
    head: {
        titleTemplate: "%s - " + process.env.npm_package_name,
        title: process.env.npm_package_name || "",
        meta: [
            { charset: "utf-8" },
            { name: "viewport", content: "width=device-width, initial-scale=1" },
            { hid: "description", name: "description", content: process.env.npm_package_description || "" }
        ],
        link: [
            { rel: "icon", type: "image/x-icon", href: "/favicon.ico" }
        ]
    },
    /**
     * Customize the progress-bar color
     */
    loading: { color: "#fff" },
    /**
     * Global CSS
     */
    css: [
        "~/assets/style/index.scss"
    ],
    /**
     * Plugins to load before mounting the App
     */
    plugins: [
        "~/plugins/i18n",
        "~/plugins/firebase",
        "~/plugins/vuelidate"
    ],
    /**
     * Nuxt.js dev-modules
     */
    buildModules: [
        "@nuxtjs/vuetify",
    ],
    /**
     * Nuxt.js modules
     */
    modules: [
        "@nuxtjs/dotenv",
        "@nuxtjs/axios",
        "@nuxtjs/toast"
    ],
    /**
     *  axios option
     *  TODO: should user proxy module in order
     *        to tackle with micro services
     */
    axios: {
        // proxyHeaders: false
        host: process.env.AXIOS_API_HOST,
        port: process.env.AXIOS_API_PORT,
        prefix: process.env.AXIOS_API_PREFIX,
        // proxyHeaders: false
        proxy: false
    },
    /**
     * vuetify module configuration
     * https://github.com/nuxt-community/vuetify-module
     */
    router: {
        middleware: ["authenticated"]
    },
    vuetify: {
        theme: {
            dark: true,
            themes: {
                dark: {
                    primary: colors.blue.darken2,
                    accent: colors.grey.darken3,
                    secondary: colors.amber.darken3,
                    info: colors.teal.lighten1,
                    warning: colors.amber.base,
                    error: colors.deepOrange.accent4,
                    success: colors.green.accent3
                }
            }
        }
    },
    toast: {
        position: "top-right",
        register: [ // Register custom toasts
            {
                name: "my-error",
                message: "Oops...Something went wrong",
                options: {
                    type: "error"
                }
            }
        ]
    },
    /**
     * Build configuration
     */
    build: {
        /**
         * You can extend webpack config here
         */
        extend (config, ctx) {
            // Run ESLint on save
            if (ctx.isDev && ctx.isClient) {
                config.module.rules.push({
                    enforce: "pre",
                    test: /\.(js|vue)$/,
                    loader: "eslint-loader",
                    exclude: /(node_modules)/
                });
            }
        }
    }
};
