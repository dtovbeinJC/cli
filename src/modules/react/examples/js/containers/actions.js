import * as PropTypes from "prop-types";
import Store from "../../store";
import {
  STEP_GAME_SELECTOR
} from "../../constants/index";

export const setNameToComponent = (componentName) => {
  return (dispatch, getState) => {
    const { stepGameSelectorReducer } = getState();
    Promise.resolve(dispatch({
      type: STEP_GAME_SELECTOR,
      payload: {
        name: componentName
      }
    }))
    .then((response) => {})
    .catch((error) => { console.log(error); })
  };
};

/* Auto-generated file created by dtovbeinJC 24/10/2018 at 13:50:52hs */

/* Auto-generated file created by dtovbeinJC 24/10/2018 at 14:07:36hs */

/* Auto-generated file created by dtovbeinJC 24/10/2018 at 14:15:00hs */

