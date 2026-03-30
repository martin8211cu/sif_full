<cfset params = "?EDvid=#form.EDvid#">

<cfif form.borrarDetalle neq 'TRUE'>
<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from EquipoDivision
		where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#"> and
		EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDid#">
	
		</cfquery>
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElEquipoDivisionYaExiste"
				Default="El Equipo-División ya existe"
				returnvariable="MSG_ElEquipoDivisionYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElEquipoDivisionYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
</cfif>

<cfif isdefined("form.ALTA")>

	<cftransaction>

	<cfinvoke component="rh.ExpDeportivo.componentes.EquipoDivision" method="ALTA" returnvariable="rs"  
	EDid="#form.EDid#" 
	TEid= "#form.TEid#" 
	conexion2="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDvid=#form.EDvid#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EquipoDivision"
		redirect="equipo-division.cfm"
		timestamp="#form.ts_rversion#"
		field1="EDvid,numeric,#form.EDvid#"
		>						
	
		<cftransaction>
		<cfinvoke component="rh.ExpDeportivo.componentes.EquipoDivision" 
		method="CAMBIO" returnvariable="rs" TEid = "#form.TEid#" EDid="#form.EDid#" EDvid="#form.EDvid#" />
		</cftransaction>
		<cfset params = params & "&EDvid=#form.EDvid#">

<cfelseif isdefined("form.borrarDetalle") and form.borrarDetalle eq 'TRUE'>
	<cftransaction>
	<cfinvoke component="rh.ExpDeportivo.componentes.EquipoDivision" method="BAJA" returnvariable="rs" 
	EDvid="#form.EDvid#" 
	EDid="#form.EDid#"
	TEid="#form.TEid#" 
	conexion="#session.dsn#"/>
	</cftransaction>
	<cfset params = params & "&EDvid=#form.EDvid#">

</cfif>
<cfset modo = "CAMBIO">
<cfif isdefined("form.popup") and form.popup eq "s">
<cfquery name="rsLista" datasource="#session.DSN#">
									select b.Edescripcion, c.TEdescripcion, e.EDvid
									from EquipoDivision e
									inner join DivisionEquipo c on
									e.TEid = c.TEid
									inner join Equipo b on
									e.EDid = b.EDid
									where EDvid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">  
								
								
	  </cfquery>	

<cfoutput>
<script>
var obj = window.parent.opener.document.getElementById('EDvid');
obj.options[obj.length] = new Option("#rsLista.TEdescripcion# - #rsLista.Edescripcion#", "#rs.identity#");
obj.selectedIndex=obj.length-1;
window.close();
</script>
</cfoutput>
<cfelse>
 <cfoutput>
<form action="equipo-division.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif not isdefined("form.BAJA")>#modo#</cfif>">
	<cfif isdefined("form.ALTA")><input name="EDvid" type="hidden" value="#rs.identity#" /><cfelse>
	<input name="EDvid" type="hidden" value="#form.EDvid#" /></cfif>
	<input name="EDid" type="hidden" value="#form.EDid#">
</form>
</cfoutput> 
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
</cfif> 