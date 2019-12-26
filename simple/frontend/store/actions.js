import axios from "axios";

export default {
    fetchItem({state, commit}, {id, resource}) {
        return new Promise((resolve) => {
		    axios.get(`http://localhost:5000/${resource}/v1/${id}`)
                .then((response) => {
                    const user = response.data.user.schema;
                    const userId = user.user_id;
                    commit("setItem", {resource, id: userId, item: user});
                    resolve(state[resource].items[user.userId]);
                });
        });
    },
};
