<cfquery datasource="asp" maxrows="50" name="data">select Usucodigo,Usulogin from Usuario</cfquery>
<cfchart 
      xAxisTitle="Department"
      yAxisTitle="Salary Average"
      font="Arial"
      gridlines=6
      showXGridlines="yes"
      showYGridlines="yes"
      showborder="yes"
      show3d="yes" 
   > 

   <cfchartseries 
      type="bar" 
      query="data" 
      valueColumn="Usucodigo" 
      itemColumn="Usulogin"
      seriesColor="olive" 
      paintStyle="plain"
   />
</cfchart>