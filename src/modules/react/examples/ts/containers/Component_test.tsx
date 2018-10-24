import React from "react";
import { render, shallow, mount } from "enzyme";
import ComponentName from "./index";
import sinon from "sinon";
import configureStore from "redux-mock-store";
import Store from "../../store";
import {
  SAMPLE_ACTION_CONSTANT
} from "../../constants/";
import * as styles from "./styles.css";

describe("Smart Component :: <ComponentName/>", () => {

  const mockStore = configureStore()({
    reducerNameReducer: {
      name: SAMPLE_ACTION_CONSTANT
    }
  });

  const _props = {
    ___name: "ComponentName"
  };

  const dispatch = sinon.spy();

  beforeEach(() => {});
  afterEach(() => {});
  beforeAll(() => {});
  afterAll(() => {});

  test("Component should receive default prop '___name' as ComponentName", () => {
    const wrapper = render(
      <ComponentName {..._props}
                     dispatch={dispatch}
                     store={mockStore}/>
    );
    expect(wrapper.prop("___name")).toBe("ComponentName")
  });

  test("Render as expected and create it's own state on the store", () => {
    const wrapper = render(
      <ComponentName {..._props}
                     dispatch={dispatch}
                     store={mockStore}
      />
    );
    expect(Store.getState().reducerNameReducer).toBeDefined();
    expect(wrapper.hasClass(`${styles.COMPONENT_CLASS_NAME}`)).toBe(true);
  });

  test("Calls componentDidMount once it's rendered", () => {
    const wrapper = render(
      <ComponentName {..._props}
                     dispatch={dispatch}
                     store={mockStore}
      />
    );
    shallow(wrapper);
    const componentDidMount = sinon.spy(ComponentName.prototype, "componentDidMount");
    expect(componentDidMount.calledOnce).toEqual(true);
  });

  test("It should have no default elements", () => {
    const wrapper = render(
      <ComponentName {..._props}
                     dispatch={dispatch}
                     store={mockStore}
      />
    );
    expect(wrapper.find(".default-component-content").length === 0).toEqual(true);
  });

  test("Check if .default-component-content class has been removed in stylesheet", () => {
    expect(false).toEqual(true);
  });
});