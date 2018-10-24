import { SAMPLE_ACTION_CONSTANT } from "CONSTANTS_PATH";
import {} from "./actions";

export interface IState {
  name: string
}

export const initialState: IState = {
  name: ""
}

export default function reducer(state=initialState, action:{ type: string, payload: object }): IState {
  switch(action.type) {
    case SAMPLE_ACTION_CONSTANT: {
      const {payload: {name}} = action;
      return {
        ...state,
        name
      };
    }
    default:
      return state;
  }
}