import React from "react";
import { Provider } from "react-redux";
import { shallow } from "enzyme";
import ComponentName from "./index";
import Store from "../../store";
import {
  setNameToComponent
} from "./actions";
import {
  SAMPLE_ACTION_CONSTANT
} from "../../constants/";

beforeEach(() => {});
afterEach(() => {});
beforeAll(() => {});
afterAll(() => {});

describe("Actions :: <ComponentName/>", () => {

  let wrapper;

  beforeEach(() => {
    wrapper = shallow( <Provider store={Store}><ComponentName /></Provider> )
  });

  test("Component <ComponentName/> should change it's name from 'null' to 'ComponentName'", () => {
    const expectedAction = {
      type: SAMPLE_ACTION_CONSTANT,
      payload: {
        name: SAMPLE_ACTION_CONSTANT
      }
    };

    expect(Store.getState().reducerNameReducer.name).toBe(null);
    expect(Store.dispatch(setNameToComponent(SAMPLE_ACTION_CONSTANT))).toEqual(expectedAction);
    expect(Store.getState().reducerNameReducer.name).toBe(SAMPLE_ACTION_CONSTANT);
  });

});