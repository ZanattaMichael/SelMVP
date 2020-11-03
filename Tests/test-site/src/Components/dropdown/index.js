import React, { Component } from "react";

function DropDown(props) {


    const select = (props) => {
        console.log("ERE A")
        console.log('props', props)
        if (props.onchange) {
            console.log("ERE1")
            return (
                    <select id={props.id} key={props.id} onChange={props.onchange}>
                        {options(props)}                      
                    </select>
                )
        } else { 
            console.log("ERE2")
            return (
                <select id={props.id} key={props.id}> 
                    {options(props)}
                </select>
            )
        }
    }

    const options = (props) => {
        return (props.options.map( option => (
            <option key={option.name} value={option.value}>{option.name}</option>
        )))   
    }

    return (
        <React.Fragment key={props.id}>
            <div>
                {console.log('id',props.id)}
                <span>{props.headerName} : </span>
                {select(props)}                                
            </div>
        </React.Fragment>
    )
}

export default DropDown;