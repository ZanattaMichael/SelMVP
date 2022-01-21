# Read-Only
New-Variable -Name HTMLFormStructure -Scope Global -Option ReadOnly -Force -Value @(
    @{
        Name = "Default"
        Properties = @(
            @{
                Name = 'Date'
                Element = $LocalizedDataHTMLElements.Date
                isRequired = $true
            }
            @{
                Name = 'Title'
                Element = $LocalizedDataHTMLElements.Title
                isRequired = $true
            }
            @{
                Name = 'URL'
                Element = $LocalizedDataHTMLElements.URL
                isRequired = $false
            }
            @{
                Name = 'Description'
                Element = $LocalizedDataHTMLElements.Description
            }            
        )
    }
    @{
        Name = "Article"
        Properties = @(
            @{
                Name = 'Number of Articles'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Number of Views'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }           
        )
    }
    @{
        Name = "Blog/WebSite Post"
        Properties = @(
            @{
                Name = 'URL'
                Element = $LocalizedDataHTMLElements.URL
                isRequired = $true
            }
            @{
                Name = 'Number of Posts'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Number of Subscribers'
                Element = $LocalizedDataHTMLElements.SecondAnnualQuantity
            },
            @{
                Name = 'Annual Unique Visitors'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                       
        )
    }
    @{
        Name = "Book (Author)"
        Properties = @(
            @{
                Name = 'Number of Books'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Copies Sold'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                       
        )
    }
    @{
        Name = "Book (Co-Author)"
        Properties = @(
            @{
                Name = 'Number of Books'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Copies Sold'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                       
        )
    }
    @{
        Name = "Conference (Staffing)"
        Properties = @(
            @{
                Name = 'Number of Conferences'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Number of Visitors'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                       
        )
    }
    @{
        Name = "Docs.Microsoft.com Contribution"
        Properties = @(
            @{
                Name = 'Pull Requests/Issues/Submissions'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }                     
        )
    }
    @{
        Name = "Forum Moderator"
        Properties = @(
            @{
                Name = 'Number of Threads moderated'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }                     
        )
    }
    @{
        Name = "Forum Participation (3rd Party forums)"
        Properties = @(
            @{
                Name = 'URL'
                Element = $LocalizedDataHTMLElements.URL
                isRequired = $true
            }
            @{
                Name = 'Number of Answers'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Number of Posts'
                Element = $LocalizedDataHTMLElements.SecondAnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Views of answers'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                   
        )
    }
    @{
        Name = "Forum Participation (Microsoft Forums)"
        Properties = @(
            @{
                Name = 'URL'
                Element = $LocalizedDataHTMLElements.URL
                isRequired = $true
            },            
            @{
                Name = 'Number of Answers'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            },
            @{
                Name = 'Number of Posts'
                Element = $LocalizedDataHTMLElements.SecondAnnualQuantity
            },
            @{
                Name = 'Views of answers'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                   
        )
    }
    @{
        Name = "Mentorship"
        Properties = @(
            @{
                Name = 'Mentoring Topic'
                Element = $LocalizedDataHTMLElements.Description
            }             
            @{
                Name = 'Number of Mentorship Activity'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Number of Mentees'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                 
        )
    }
    @{
        Name = "Microsoft Open Source Projects"
        Properties = @(           
            @{
                Name = 'Number of Projects'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }                             
        )
    }
    @{
        Name = "Non-Microsoft Open Source Projects"
        Properties = @(
            @{
                Name = 'Projects(s)'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Contribution(s)'
                Element = $LocalizedDataHTMLElements.SecondAnnualQuantity
            }                                            
        )
    }
    @{
        Name = "Organizer (User Group/Meetup/Local Events)"
        Properties = @(
            @{
                Name = 'Meetings'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Members'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Organizer of Conference"
        Properties = @(
            @{
                Name = 'Number of Conferences'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Number of Attendees'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Other"
        Properties = @(
            @{
                Name = 'Annual quantity'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Annual reach'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }  
    @{
        Name = "Product Group Feedback"
        Properties = @(
            @{
                Name = 'Number of Events Participated'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Number of Feedbacks Provided'
                Element = $LocalizedDataHTMLElements.SecondAnnualQuantity
            }                                            
        )
    }
    @{
        Name = "Sample Code/Projects/Tools"
        Properties = @(
            @{
                Name = 'URL'
                Element = $LocalizedDataHTMLElements.URL
                isRequired = $true
            }            
            @{
                Name = 'Number of Samples'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Number of Downloads'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Site Owner"
        Properties = @(          
            @{
                Name = 'Number of Sites'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Number of Visitors'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Speaking (Conference)"
        Properties = @(          
            @{
                Name = 'Number of Talks'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Attendees of Talks'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Speaking (User Group/Meetup/Local events)"
        Properties = @(          
            @{
                Name = 'Number of Talks'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Attendees of Talks'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Technical Social Media (Twitter, Facebook, LinkedIn...)"
        Properties = @(
            @{
                Name = 'URL'
                Element = $LocalizedDataHTMLElements.URL
                isRequired = $true
            }                    
            @{
                Name = 'Number of Talks'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Number of Followers'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Translation Review, Feedback and Editing"
        Properties = @(          
            @{
                Name = 'Annual quantity'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }                                         
        )
    }
    @{
        Name = "Video/Webcast/Podcast"
        Properties = @(
            @{
                Name = 'URL'
                Element = $LocalizedDataHTMLElements.URL
                isRequired = $true
            }                   
            @{
                Name = 'Number of Videos'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }
            @{
                Name = 'Number of Views'
                Element = $LocalizedDataHTMLElements.AnnualReach
            }                                            
        )
    }
    @{
        Name = "Workshop/Volunteer/Proctor"
        Properties = @(          
            @{
                Name = 'Number of Events'
                Element = $LocalizedDataHTMLElements.AnnualQuantity
                isRequired = $true
            }                                          
        )
    }                       
)
