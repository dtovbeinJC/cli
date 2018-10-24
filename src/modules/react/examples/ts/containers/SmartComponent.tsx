import * as React from "react";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import {} from "./helpers";
import { trimClassNames } from "../../utils/_helpers";
import { setNameToComponent } from "./actions";
import * as CSSVariables from "../../sass/_variables.js";
import styles from "./styles.css";

export interface IProps {
  reducerNameReducer: object,
  setNameToComponent: any
}

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
    const { setNameToComponent } = this.props;
    const { __name } = this.state;

    const promises = [
      setNameToComponent(__name)
    ];

    Promise.all(promises)
      .then((payload: any) => {})
      .catch((error: any) => console.log(error));
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
      <MAIN_TAG className={trimClassNames(["componentClass",
                                           styles.COMPONENT_CLASS_NAME])}>

        {/* Default content */}
        <div ref={node => this.defaultComponentContent = node}
             className={styles.defaultComponentContent} 
             style={{ backgroundColor:"#3585b1", border:"solid 1px #bcbcbc", marginBottom:".5rem", padding:"1rem" }}>
          <h1 style={{ textAlign:"center", fontSize:"1.25rem"}}>SampleComponent <span style={{ fontWeight:"bold", textDecoration:"underline"}}>as a container</span></h1>
          <p style={{ fontSize:"1rem", textAlign:"center" }}>This is a default content for 'componentClass'.</p>
          <p style={{ color:"black", fontSize:".95rem", textAlign:"center" }}>
            Default value from reducer: <span style={{ textDecoration:"underline" }}>{ this.props.reducerNameReducer.name }</span>
          </p>
          <p style={{ color:"red", fontSize:".85rem", textAlign:"center" }}>** Please remove it and it's reference on css file! **</p>
        </div>
        {/* End default content */}

      </MAIN_TAG>
    );
  }
}

export default connect(
  store => ({
    reducerNameReducer: store.reducerNameReducer
  }),
  dispatch => bindActionCreators({
    setNameToComponent
  }, dispatch))(SampleComponent);