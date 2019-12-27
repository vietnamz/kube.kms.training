import {helpers as vuelidateHelpers} from "vuelidate/lib/validators";

/*
export const uniqueEmail = (value) => {
    if (!vuelidateHelpers.req(value)) {
        return true;
    }
    return new Promise((resolve) => {
        axios.get(`http://localhost:5000/users/v1/email/${value}`)
            .catch(()=> resolve(true))
            .then(()=> resolve(false));
    });
};


export const emailNotExist = (value) => {
    if (!vuelidateHelpers.req(value)) {
        return true;
    }
    return new Promise((resolve) => {
        axios.get(`http://localhost:5000/users/v1/email/${value}`)
            .catch(()=> resolve(false))
            .then(()=> resolve(true));
    });
};
*/

export function uniqueEmail (value) {
    if (!vuelidateHelpers.req(value)) {
        return false;
    }
    return new Promise((resolve) => {
        this.$axios.get(`/users/v1/email/${value}`)
            .catch(()=> resolve(true))
            .then( (response) => {
                console.log("uniqueEmail " + response.data);
                if (response.data) {
                    resolve(false);
                } else {
                    resolve(true);
                }
            });
    });
};
  
export function emailNotExist (value) {
    if (!vuelidateHelpers.req(value)) {
        return false;
    }
    return new Promise((resolve) => {
        this.$axios.get(`/users/v1/email/${value}`)
            .catch(()=> resolve(true))
            .then( (response) => {
                if (response.data) {
                    resolve(true);
                } else {
                    resolve(false);
                }
            });
    });
};