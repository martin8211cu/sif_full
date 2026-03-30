<!---
<cfset LvarLista="">
<cfloop list="sybase,sqlserver,oracle,db2" index="db">
	<cfset LvarOBJ.script_BASECERO(6, "#db#")>
</cfloop>
<cfquery name="rsSQL" datasource="asp">
  select * from DBMtab
   where IDsch = 1
</cfquery>

<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_mssql",0)>
<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_sybase",0)>
<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_oracle",0)>

<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_mssql",0)>
<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_sybase",0)>
<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_oracle",0)>
<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_db2",0)>

--->

<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfset LvarObj.XML_toDB("dbm_db2",0)>