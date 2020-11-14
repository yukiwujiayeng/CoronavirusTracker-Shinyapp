###App Details

####**global.R**

The **global.R** file loads all packages required for the app and access to COVID-19 Data Tracking API to extract the relevant bits of data into a data frame **df**, then create the data sets **Global_data2** and **Global_data**. These included data wrangling for each data frame , where **df** is a data frame group by country which includes each country cumulative cases and **Global_data2** is a tibble group by date and it includes cumulative cases as well. These 2 data sets are the data set we are going to use across the whole app.


####**ui.R**

In the ui.R file we use `shinydashboard` and `shinythemes` packages to create an app with theme `flatly` and 3 different tab Panels: **Daily Outbreak**, **Data**, **Outbreak comparisons**. 

The sidebar for each tab panel to the left contains option for user to select multiple countries (`pickerInput` function for **Outbreak comparisons** panel,`selectInput` function for the the other 2 panels), date (`selectInput` function, only appear in **Daily Outbreak** panel), date range (`dateRangeInput` function) and data level (`pickerInput` function, only appear in **Outbreak comparisons** panel) as well as Refresh button and download button

Each panel give a different output in the main panel. We use `plotlyOutput` function for all the plotting output and use `DT::dataTableOutput()` function to give data table output. 

####**server.R**

We split the **server.R** into 3 parts,each part represent the analysis and output needed for a different panel. (All the data set and plots create in the **server.R** make use of `reactive` function and `renderPlotly` function, respectively.)

* The first part is to deal with the **Daily Outbreak** panel. The App first creates a data set called  selectedData with the country and date selected by the user, then use the selectedData to create another dataset (number of confirmed or deaths cases data) wanted by the user and plots a bar chart of this newData.

* The second part is responsible for the **Data** panel. It creates a new data set called selectedData2 which filter the date range, data type (number of confirmed or deaths cases data) and countries chosen by the user to generate a data table in the output using `DT::renderDataTable` function.

* The third part is to generate the output of the **Outbreak comparisons** panel. We make use of `observeEvent` function to update region level selections (i.e. Country or Global). With this function we can change the choice for the sidebar. (i.e. If the level 'Country' is selected,the **Country** filed in the sidebar will be giving choices with all the countries in the world. However, if 'Global' level is selected then the choice in the **Country** filed in the sidebar will be left with global only.)**datasetInput_cumulative** is a reative data set include function of switching dataset for different level.  Then similar to the first part, the App creates the date range, country, data type (number of confirmed or deaths cases data) wanted by the user from **datasetInput_cumulative** and creates linear line plots for daily cases and cumulative cases of newData3 and newData2, respectively. There are  negative and zero value for deaths or confirmed case number from the resource.In order to prevent the log plot get to negative infinite or NaNs, we create newData4 from newData3 using the `replace` function to change all cases number smaller or equal to 0 to 1 [ln(1)=0] to create log line plots of it. 

 


