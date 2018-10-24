import * as React from "react";
import * as PropTypes from "prop-types";
import {} from "./helpers";
import { trimClassNames } from "../../utils/_helpers";
import * as CSSVariables from "../../sass/_variables";
import styles from "./styles.css";

export interface IProps {}

export interface IState {
  __name: string
}

class SampleComponent extends React.Component<IProps, IState> {

  static defaultProps: Partial<IProps> = {};

  constructor(props: IProps) {
    super(props);

    this.state = {
      __name: "SampleComponent"
    };
  }

  componentDidMount() {
  }

  componentWillMount() {
    this.setState({}, () => {});
  }

  componentWillReceiveProps(nextProps: IProps) {
  }

  shouldComponentUpdate(nextProps: IProps, nextState: IState) {
    return true;
  }

  componentWillUpdate(nextProps: IProps, nextState: IState) {
  }

  componentDidUpdate(prevProps: IProps, prevState: IState) {
  }

  componentWillUnmount() {
  }

  render() {
    return (
      <div className={trimClassNames(["componentClass",
                                      styles.COMPONENT_CLASS_NAME])}>

        {/* Default content */}
        <div ref={node => this.defaultComponentContent = node}
             className={styles.defaultComponentContent}
             style={{backgroundColor: "#9cc51c", borderRadius: "3px", marginBottom: ".5rem", padding: "1rem"}}>
          <h1 style={{textAlign: "center", fontSize: "1.25rem"}}>SampleComponent <span
            style={{fontWeight: "bold", textDecoration: "underline"}}>as a class component</span></h1>
          <p style={{fontSize: "1rem", textAlign: "center"}}>This is a default content for
            'componentClass'.</p>
          <p style={{color: "red", fontSize: ".85rem", textAlign: "center"}}>** Please remove it and it's
            reference on css file! **</p>
        </div>
        {/* End default content */}

      </div>
    );
  }
}

export default SampleComponent;

