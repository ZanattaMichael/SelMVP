import React, { Component } from "react";
import NewActivity from "../NewActivity"

class Contributions extends Component {

    state = {
        isActive:false
    }

    handleShow = () => {
        console.log("ERE");
        this.setState({isActive: true})        
    }

    handleHide = () => {
        console.log('hiding')
        this.setState({isActive: false})
    }

    render () {
        return (
            <div>
                <h1>Phony Contributions Page</h1>
                <button id='addNewActivityBtn' onClick={this.handleShow}>addNewActivityBtn</button>
                { 
                    this.state.isActive ? <NewActivity onClose={this.handleHide}></NewActivity> : null
                }
            </div>
        )
    }
}

export default Contributions;
  