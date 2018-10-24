import React from "react";
import { render, shallow, mount } from "enzyme";
import ComponentName from "./index";
import styles from "./styles.css";

describe("Standard Component :: <ComponentName/>", () => {

  const _props = {
    ___name: "ComponentName"
  };

  beforeEach(() => {});
  afterEach(() => {});
  beforeAll(() => {});
  afterAll(() => {});

  test("Component should receive default prop '___name' as ComponentName", () => {
    const wrapper = mount(
      <ComponentName {..._props} />
    );
    expect(wrapper.prop("___name")).toBe("ComponentName")
  });

  test("Render component as expected", () => {
    const wrapper = mount(
      <ComponentName {..._props} />
    );
    expect(wrapper.hasClass(`${styles.COMPONENT_CLASS_NAME}`)).toBe(true);
  });

  test("It should have no default elements", () => {
    const wrapper = mount(
      <ComponentName {..._props} />
    );
    expect(wrapper.find('.default-component-content').length).toEqual(0);
  });

  test("Check if .default-component-content class has been removed in stylesheet", () => {
    expect(false).toEqual(true);
  });

});