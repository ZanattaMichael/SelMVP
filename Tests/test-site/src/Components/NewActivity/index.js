import React, { Component, useState } from "react";
import DropDown from '../dropdown'

const areaOptions = [
    {
        name: "empty",
        value: "empty"
    },
    {
      name: 'Blog/Website Post',
      value: 'df6464de-179a-e411-bbc8-6c3be5a82b68'
    },
    {
      name: 'Book (Author)',
      value: 'db6464de-179a-e411-bbc8-6c3be5a82b68'
    },
    {
      name: 'Book (Co-Author)',
      value: 'dd6464de-179a-e411-bbc8-6c3be5a82b68'
    },
    {
        name: 'Conference (Staffing)',
        value: 'f16464de-179a-e411-bbc8-6c3be5a82b68'
      }        
  ]
  
const contributionArea = {

}

const configuration = {

}

function NewActivity (props) {

    const [stateButton, setStateButton] = useState(0);

    return (
            <div>
                <p>Mock Buttons</p>
                <button class='ui-button-text'>Save</button>
                <button id='submitCloseButton'>Cancel</button>
                <p>Mock Form</p>
                <DropDown id='activityTypeSelector' name='Activity' options={areaOptions} headerName='Activity type'></DropDown>
                <DropDown id='select_contributionAreasDDL' name='ContributionArea' options={areaOptions} headerName='Primary Contribution Area'></DropDown>
                <DropDown id='select_contributionAreasDDL2' name='ContributionArea2' options={areaOptions} headerName='Secondary Contribution Area'></DropDown>
                <button class='add' onClick={ () => {setStateButton(true)}}>add more</button>
                { stateButton ? <DropDown id='select_contributionAreasDDL3' name='ContributionArea3' options={areaOptions} headerName='Third Contribution Area'></DropDown> : null }
            </div>

        )
}

export default NewActivity;
  