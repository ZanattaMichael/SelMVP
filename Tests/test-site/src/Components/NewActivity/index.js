import React, { Component, useState } from "react";
import DropDown from '../dropdown'

const areaOptions = [
    {
        id : 0,
        name: "Article",
        value: "e36464de-179a-e411-bbc8-6c3be5a82b68"
    },  
    {
      id : 1,
      name: 'Blog/Website Post',
      value: 'df6464de-179a-e411-bbc8-6c3be5a82b68'
    },
    {
      id : 2,
      name: 'Book (Author)',
      value: 'db6464de-179a-e411-bbc8-6c3be5a82b68'
    },
    {
      id : 3,
      name: 'Book (Co-Author)',
      value: 'dd6464de-179a-e411-bbc8-6c3be5a82b68'
    },
    {
        id : 4,
        name: 'Conference (Staffing)',
        value: 'f16464de-179a-e411-bbc8-6c3be5a82b68'
      }        
  ]
  
const contributionArea = [
  {
    id : 0,
    name: 'Chef/Puppet in Datacenter',
    value: 'b803f4ef-066b-e511-810b-fc15b428ced0'
  },
  {
    id : 1,
    name: 'Container Management',
    value: 'be03f4ef-066b-e511-810b-fc15b428ced0'
  },
  {
    id : 1,
    name: 'Datacenter Management',
    value: 'c603f4ef-066b-e511-810b-fc15b428ced0'
  }  
]

const configuration = [
  {
    id: 0,
    Name: "Article",
    Elements: [ 
      {
        headingName: "Date of Activity",
        id: 'DateOfActivity'
      },
      {
        headingName: "Title of Activity",
        id: 'TitleOfActivity'
      },
      {
        headingName: "URL",
        id: 'ReferenceUrl'
      },
      {
        headingName: "Description",
        id: 'Description'
      },
      {
        headingName: "Number of Articles",
        id: 'AnnualQuantity'
      },
      {
        headingName: "Number of Views",
        id: 'AnnualReach'
      }
    ]            
  },  
  {
    Name: "Blog/Website Post",
    Elements: [ 
      {
        headingName: "Date of Activity",
        id: 'DateOfActivity'
      },
      {
        headingName: "Title of Activity",
        id: 'TitleOfActivity'
      },
      {
        headingName: "URL",
        id: 'ReferenceUrl'
      },
      {
        headingName: "Description",
        id: 'Description'
      },
      {
        headingName: "Number of Posts",
        id: 'AnnualQuantity'
      },
      {
        headingName: "Number of Subscribers",
        id: 'SecondAnnualQuantity'
      },
      {
        headingName: "Annual Unique Visitors",
        id: 'AnnualReach'
      }
    ] 
  },
  {
    Name: "Book (Author)",
    Elements: [ 
      {
        headingName: "Date of Activity",
        id: 'DateOfActivity'
      },
      {
        headingName: "Title of Activity",
        id: 'TitleOfActivity'
      },
      {
        headingName: "URL",
        id: 'ReferenceUrl'
      },
      {
        headingName: "Description",
        id: 'Description'
      },
      {
        headingName: "Number of Books",
        id: 'AnnualQuantity'
      },
      {
        headingName: "Copies Sold",
        id: 'AnnualReach'
      }
    ] 
  },
  {
    Name: "Book (Co-Author)",
    Elements: [ 
      {
        headingName: "Date of Activity",
        id: 'DateOfActivity'
      },
      {
        headingName: "Title of Activity",
        id: 'TitleOfActivity'
      },
      {
        headingName: "URL",
        id: 'ReferenceUrl'
      },
      {
        headingName: "Description",
        id: 'Description'
      },
      {
        headingName: "Number of Books",
        id: 'AnnualQuantity'
      },
      {
        headingName: "Copies Sold",
        id: 'AnnualReach'
      }
    ]
  },
  {
    Name: "Conference (Staffing)",
    Elements: [ 
      {
        headingName: "Date of Activity",
        id: 'DateOfActivity'
      },
      {
        headingName: "Title of Activity",
        id: 'TitleOfActivity'
      },
      {
        headingName: "URL",
        id: 'ReferenceUrl'
      },
      {
        headingName: "Description",
        id: 'Description'
      },
      {
        headingName: "Number of Conferences",
        id: 'AnnualQuantity'
      },
      {
        headingName: "Number of Visitors",
        id: 'AnnualReach'
      }
    ] 
  }
]

function NewActivity (props) {

    const [stateButton, setStateButton] = useState(0);
    const [stateForm, setStateForm] = useState(1);

    const updateState = (props, value) => {
      setStateForm({
        id: value
      })
      console.log('clicked');
    }

    return (
            <div>
                <p>Mock Buttons</p>
                <button class='ui-button-text'>Save</button>
                <button id='submitCloseButton'>Cancel</button>
                <p>Mock Form</p>
                <DropDown id='activityTypeSelector' name='Activity' options={areaOptions} headerName='Activity type' defaultValue={areaOptions[0].value} onchange={setStateForm}></DropDown>
                <DropDown id='select_contributionAreasDDL' name='ContributionArea' options={contributionArea} headerName='Primary Contribution Area'></DropDown>
                <DropDown id='select_contributionAreasDDL2' name='ContributionArea2' options={contributionArea} headerName='Secondary Contribution Area'></DropDown>
                <button class='add' onClick={ () => { updateState() }}>add more</button>
                { stateButton ? <DropDown id='select_contributionAreasDDL3' name='ContributionArea3' options={contributionArea} headerName='Third Contribution Area'></DropDown> : null }
                { 

                }
            </div>

        )
}

export default NewActivity;
  