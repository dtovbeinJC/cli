import Store from "../../store";
import {
  SAMPLE_ACTION_CONSTANT
} from "../../constants/index";

export const setNameToComponent = (componentName:string) => {
  return (dispatch:Store.dispatch, getState:any) => {
    const { reducerNameReducer } = getState();
    Promise.resolve(dispatch({
      type: SAMPLE_ACTION_CONSTANT,
      payload: {
        name: componentName
      }
    }))
    .then((response: object) => {})
    .catch((error: any) => { console.log(error); })
  };
};

