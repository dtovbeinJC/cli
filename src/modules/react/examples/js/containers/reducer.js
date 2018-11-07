import { SAMPLE_ACTION_CONSTANT } from "CONSTANTS_PATH";
import {SAMPLE_ACTION_CONSTANT} from "./actions";

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

    case `${SAMPLE_ACTION_CONSTANT}_REQUEST`: {
      return {
        ...state
      }
    }

    case `${SAMPLE_ACTION_CONSTANT}_SUCCESS`: {
      return {
        ...state
      }
    }

    case `${SAMPLE_ACTION_CONSTANT}_FAILED`: {
      return {
        ...state
      }
    }

    default:
      return state;
  }
}