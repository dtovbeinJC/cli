import {
  SAMPLE_ACTION_CONSTANT
} from "CONSTANTS_PATH";

import Reducer, { initialState } from "./reducer";

beforeEach(() => {});
afterEach(() => {});
beforeAll(() => {});
afterAll(() => {});

describe("Reducer :: <ComponentName/>", () => {

  test("Has an initial state", () => {

    const initialStateExpected = {
      name: ""
    };

    expect(Reducer(undefined, {
      type: "unexpected",
      payload: null
    })).toEqual({
      ...initialStateExpected
    });
  });

  test(`'name' value should be the same as '${SAMPLE_ACTION_CONSTANT}' when the action is '${SAMPLE_ACTION_CONSTANT}'`, () => {
    expect(Reducer(undefined, {
      type: SAMPLE_ACTION_CONSTANT,
      payload: {
        name: SAMPLE_ACTION_CONSTANT
      }
    })).toEqual({
      ...initialState,
      name: SAMPLE_ACTION_CONSTANT
    });
  });
});



