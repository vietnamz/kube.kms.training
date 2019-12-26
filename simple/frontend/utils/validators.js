import {helpers as vuelidateHelpers} from "vuelidate/lib/validators";
import axios from "axios";

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
