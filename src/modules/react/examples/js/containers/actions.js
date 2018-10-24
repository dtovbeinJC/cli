import * as PropTypes from "prop-types";
import Store from "../../store";
import {
  SAMPLE_ACTION_CONSTANT
} from "../../constants/index";

export const setNameToComponent = (componentName) => {
  return (dispatch, getState) => {
    const { reducerNameReducer } = getState();
    Promise.resolve(dispatch({
      type: SAMPLE_ACTION_CONSTANT,
      payload: {
        name: componentName
      }
    }))
    .then((response) => {})
    .catch((error) => { console.log(error); })
  };
};

