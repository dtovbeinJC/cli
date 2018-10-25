
import {
  SAMPLE_ACTION_CONSTANT
} from "../../constants/index";

export const setNameToComponent = (componentName) => (dispatch, getState) => {
  return new Promise((resolve, reject) => {
    const { reducerNameReducer } = getState();
    return resolve(dispatch({
      type: SAMPLE_ACTION_CONSTANT,
      payload: {
        name: componentName
      }
    }));
  })
    .then((payload) => Promise.resolve({...payload}))
    .catch((error) => Promise.reject({...error}));
};