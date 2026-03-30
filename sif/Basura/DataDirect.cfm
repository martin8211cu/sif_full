<cfset drivernames = "macromedia.jdbc.oracle.OracleDriver, macromedia.jdbc.db2.DB2Driver, macromedia.jdbc.informix.InformixDriver, macromedia.jdbc.sequelink.SequeLinkDriver, macromedia.jdbc.sqlserver.SQLServerDriver, macromedia.jdbc.sybase.SybaseDriver">
<cfset drivernames=Replace(drivernames," ","","ALL")><!--- replace all spaces --->
<cfloop index="drivername" list="#drivernames#">
 <cfobject action="CREATE" class="#drivername#" name="driver" type="JAVA">
 <cfset args= ArrayNew(1)>
 <cfset driver.main(args)>
 <cfdump var="#driver#">
 <cfoutput>#driver.getMajorVersion()# #driver.getMinorVersion()#</cfoutput>
</cfloop>


