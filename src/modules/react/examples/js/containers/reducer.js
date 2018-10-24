import { STEP_GAME_SELECTOR } from "../../constants/";
import {} from "./actions";


export const initialState = {
  name: ""
}

export default function reducer(state=initialState, action) {
  switch(action.type) {
    case STEP_GAME_SELECTOR: {
      return {
        ...state,
        name: action.payload.name
      };
    }
    default:
      return state;
  }
}/* Auto-generated file created by dtovbeinJC 24/10/2018 at 13:50:53hs */

/* Auto-generated file created by dtovbeinJC 24/10/2018 at 14:07:36hs */

/* Auto-generated file created by dtovbeinJC 24/10/2018 at 14:15:01hs */

