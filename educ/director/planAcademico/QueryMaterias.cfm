<!--- Recibe form, cod, name, conexion, desc, dato --->
<cfinclude template="/educ/queries/qryEscuela.cfm">
<cfset codsMat = ValueList(rsEscuela.EScodigo)> 

<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#url.conexion#">
		select convert(varchar, Mcodigo) as Mcodigo, Mcodificacion, Mnombre
		from Materia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
 			and rtrim(ltrim(upper(Mcodificacion))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(Trim(url.dato))#">		
  			<cfif isdefined("url.quitar") and url.quitar NEQ "">
				and Mcodigo not in (#url.quitar#)
			</cfif>				
			and Mactivo = 1 
			and ((EScodigo in (#codsMat#)) or (MotrasCarreras = 1))
	</cfquery>

	<!--- Si encontro la materia la despliega en los campos respectivos --->
	<cfif isdefined('rs') and rs.recordCount GT 0 and len(trim(rs.Mcodigo)) NEQ 0>
		<script language="JavaScript">
			parent.document.<cfoutput>#url.form#.#url.cod#</cfoutput>.value="<cfoutput>#rs.Mcodigo#</cfoutput>";
			parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.Mcodificacion#</cfoutput>";			
			parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Mnombre#</cfoutput>";
			parent.document.<cfoutput>#Url.form#</cfoutput>.submit();			
		</script>
	<cfelse>
		<script language="JavaScript">	
			parent.abreConlisMat();			
		</script>			
	</cfif>
</cfif>
