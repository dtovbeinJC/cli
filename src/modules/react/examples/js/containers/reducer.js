import { SAMPLE_ACTION_CONSTANT } from "CONSTANTS_PATH";
import {} from "./actions";


export const initialState = {
  name: ""
}

export default function reducer(state=initialState, action) {
  switch(action.type) {
    case SAMPLE_ACTION_CONSTANT: {
      return {
        ...state,
        name: action.payload.name
      };
    }
    default:
      return state;
  }
}