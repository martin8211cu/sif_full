<cfif isdefined("Form.Cambio")>
	<cfset action="Existencias.cfm" >
	<cfloop index = "index" list = "#Form.Alm_Aid#" delimiters = ",">
		<!-- Variables a procesar -->
		<cfset asiento    = "IACcodigo_#index#" >
		<cfset estante    = "Eestante_#index#" >
		<cfset casilla    = "Ecasilla_#index#" >
		<cfset minimo     = "Eexistmin_#index#" >
		<cfset maximo     = "Eexistmax_#index#" >
		<cfset existencia = "Eexistencia_#index#" >
		<cfset costo      = "Ecostou_#index#" >
		
		<!-- variables default para insert -->
		<cfset preciocompra = "0" >
		<cfset costototal   = "0" >
		<cfset salidas      = "0" >
		<cfquery name="rsExistencias" datasource="#session.DSN#">
			select 1 
			from Existencias 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
			  and Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
			  and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#index#" >			
		</cfquery>
		
		<cfif isdefined('rsExistencias') and rsExistencias.recordCount EQ 0>
			<cfquery datasource="#session.DSN#">
				insert INTO Existencias ( Aid, Alm_Aid, Ecodigo, IACcodigo, Eexistencia, Ecostou, Epreciocompra, 
									 Ecostototal,Esalidas, Eestante, Ecasilla, Eexistmin, Eexistmax ) 
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#index#" >,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form[asiento]#" >,
						 0,
						 0,
						 0,
						 0,
						 0,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form[estante]#" >,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form[casilla]#" >,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(Form[minimo],',','','all')#" >,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(Form[maximo],',','','all')#" > ) 				
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update Existencias 
				set IACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form[asiento]#" >,
					Eestante  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form[estante]#" >,
					Ecasilla  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form[casilla]#" >,
					Eexistmin = <cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(Form[minimo],',','','all')#" >,
					Eexistmax = <cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(Form[maximo],',','','all')#" >
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				  and Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
				  and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#index#" >				
			</cfquery>
		</cfif>
	</cfloop>
	<!---Obtener los almacenes que habian sido agregados anteriormente---->
	<cfquery name="rsAnteriores" datasource="#session.DSN#">
		select Aid, Alm_Aid 
		from Existencias 
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" > 
		and Alm_Aid not in (#Form.Alm_Aid#)
	</cfquery>
	<cfset vnAlmacenes = valuelist(rsAnteriores.Alm_Aid)><!----Almacenes anteriores---->
	<cfif len(trim(vnAlmacenes))>
		<cfquery datasource="#session.DSN#"><!---Eliminar los almacenes anteriores---->
			delete from Existencias
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" > 
				and Alm_Aid in (#vnAlmacenes#)
		</cfquery>
	</cfif>
</cfif>

<cfset params="">
<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>
	<cfset params= params&'&filtro_Acodigo='&form.filtro_Acodigo>	
	<cfset params= params&'&hfiltro_Acodigo='&form.filtro_Acodigo>		
</cfif>
<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>
	<cfset params= params&'&filtro_Acodalterno='&form.filtro_Acodalterno>	
	<cfset params= params&'&hfiltro_Acodalterno='&form.filtro_Acodalterno>	
</cfif>
<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>
	<cfset params= params&'&filtro_Adescripcion='&form.filtro_Adescripcion>	
	<cfset params= params&'&hfiltro_Adescripcion='&form.filtro_Adescripcion>	
</cfif>

<cfif isdefined('form.Regresar')>
	<cflocation url="articulos-lista.cfm?Pagina=#Form.Pagina##params#">
<cfelse>
	<cflocation url="Existencias.cfm?Aid=#form.Aid#&Pagina=#Form.Pagina##params#">
</cfif>




<!--- 

<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Aid" type="hidden" value="<cfif isdefined("Form.Aid")><cfoutput>#Form.Aid#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML> --->