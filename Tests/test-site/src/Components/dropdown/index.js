import React, { Component } from "react";

function DropDown(props) {
    return (
        <React.Fragment key={props.id}>
            <div>
                {console.log('id',props.id)}

                <span>{props.headerName} : </span>
                <select id={props.id} key={props.id}>
                    {
                        props.options.map( option => (
                            <option key={option.name} value={option.value}>{option.name}</option>
                        ))
                    }
                </select>
            </div>
        </React.Fragment>
    )
}

export default DropDown;