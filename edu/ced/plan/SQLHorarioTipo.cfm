<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 25 de febrero del 2006
	Motivo: Actualización de fuentes de educación a nuevos estándares de Pantallas y Componente de Listas.
 --->
<cfset params="">
<cfset pagina2 = "1">
<cfset pagina = "1">
<cfif not isdefined('form.Nuevo') and not isdefined('form.NuevoDet')>
	<cftransaction>
	<cfif isdefined('form.Alta')>
		<!--- Caso 1: Agregar Encabezado --->
		<cfquery name="rsInsertE" datasource="#session.Edu.DSN#">
			insert HorarioTipo (CEcodigo, Hnombre)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Hnombre#">
					)
			<cf_dbidentity1 datasource="#session.Edu.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.Edu.DSN#" name="rsInsertE">
		<cfset form.Hcodigo = rsInsertE.identity>
		<cfset params=params&"Hcodigo="&rsInsertE.identity>
	<cfelseif isdefined('form.Cambio')>
		<!--- Caso 2: Modificar Encabezado --->
		<cfquery name="rsUpdateE" datasource="#session.Edu.DSN#">
			update HorarioTipo
			   set Hnombre = <cfqueryparam value="#form.Hnombre#" cfsqltype="cf_sql_varchar">
			 where Hcodigo = <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
			   and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		</cfquery>
		<cfset pagina2 = form.Pagina2>
		<cfset params=params&"Hcodigo="&form.Hcodigo>
	<cfelseif isdefined('form.Baja')>
		<!--- Caso 3: Eliminar Encabezado --->
		<cfquery name="rsDeleteE" datasource="#session.Edu.DSN#">
			delete Horario 
			from  Horario a , HorarioTipo b
			where a.Hcodigo=<cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">				
			  and b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and a.Hcodigo = b.Hcodigo 
		</cfquery>
		<cfquery name="rsDeleteHA" datasource="#session.Edu.DSN#">
			delete HorarioAplica
			where Hcodigo=<cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="rsDeleteHT" datasource="#session.Edu.DSN#">
			delete HorarioTipo
			where Hcodigo=<cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
			  and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		</cfquery>
		<cfset pagina2 = form.Pagina2>
	<cfelseif isdefined('form.AltaDet')>
		<!--- Caso 4: Agregar Detalle --->
		<cfquery name="rsInsertD" datasource="#session.Edu.DSN#">
			insert Horario 
				(Hcodigo, Hbloquenombre, Hentrada, Hsalida, Htipo)
				values (<cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#form.Hbloquenombre#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#form.Hentrada&'.'&form.HentradaMin#" cfsqltype="cf_sql_float">,
						<cfqueryparam value="#form.Hsalida&'.'&form.HsalidaMin#" cfsqltype="cf_sql_float">,
						<cfqueryparam value="#form.Htipo#" cfsqltype="cf_sql_smallint">)			
			<cf_dbidentity1 datasource="#session.Edu.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.Edu.DSN#" name="rsInsertD">
		<cfset form.Hbloque = rsInsertD.identity>
		<cfquery name="rsUpdateE" datasource="#session.Edu.DSN#">
			update HorarioTipo
			set Hnombre = <cfqueryparam value="#form.Hnombre#" cfsqltype="cf_sql_varchar">
			where Hcodigo = <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
			  and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		</cfquery>
		<cfquery name="rsPagina" datasource="#Session.Edu.DSN#">
			SELECT count(1) as Cont
			FROM  Horario
			WHERE Hcodigo = <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset pagina2 = Ceiling(rsPagina.Cont / form.MaxRows)>
		<cfset params=params&"Hcodigo="&form.Hcodigo&"&Hbloque="&rsInsertD.identity>
	<cfelseif isdefined('form.CambioDet')>
		<!--- Caso 5: Modificar Detalle --->
		<cfquery name="rsUpdateD" datasource="#session.Edu.DSN#">
			update Horario
			set	Hbloquenombre =	<cfqueryparam value="#form.Hbloquenombre#" cfsqltype="cf_sql_varchar">,
				Hentrada = <cfqueryparam value="#form.Hentrada&'.'&form.HentradaMin#" cfsqltype="cf_sql_float">,
				Hsalida  = <cfqueryparam value="#form.Hsalida&'.'&form.HsalidaMin#" cfsqltype="cf_sql_float">,
				Htipo  	 = <cfqueryparam value="#form.Htipo#" cfsqltype="cf_sql_smallint">
			from Horario a , HorarioTipo b					
			where a.Hcodigo = <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
			  and Hbloque = <cfqueryparam value="#form.Hbloque#" cfsqltype="cf_sql_numeric">
			  and b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and a.Hcodigo = b.Hcodigo 
		</cfquery>
		<cfquery name="rsUpdateE" datasource="#session.Edu.DSN#">
			update HorarioTipo
			set Hnombre = <cfqueryparam value="#form.Hnombre#" cfsqltype="cf_sql_varchar">
			where Hcodigo = <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
			  and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		</cfquery>
		<cfset pagina2 = form.Pagina2>
		<cfset params=params&"Hcodigo="&form.Hcodigo&"&Hbloque="&form.Hbloque>
	<cfelseif isdefined('form.BajaDet')>
		<!--- Caso 5: Eliminar Detalle --->
		<cfquery name="rsDeleteD" datasource="#session.Edu.DSN#">
			delete Horario 
				from Horario a , HorarioTipo b					
				where a.Hcodigo = <cfqueryparam value="#form.Hcodigo#" cfsqltype="cf_sql_numeric">
				  and Hbloque = <cfqueryparam value="#form.Hbloque#" cfsqltype="cf_sql_numeric">
				  and b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				  and a.Hcodigo = b.Hcodigo 
		</cfquery>
		<cfset params=params&"Hcodigo="&form.Hcodigo>
	</cfif>
	</cftransaction>
<cfelseif isdefined('form.NuevoDet')>
	<cfset params=params&"Hcodigo="&form.Hcodigo>
</cfif>
<cfset pagina = form.Pagina>

<cfif isdefined('form.Baja')>
	<cflocation url="listaHorarioTipo.cfm?Pagina=#pagina#&Filtro_NombreBloque=#Form.Filtro_NombreBloque#&Filtro_Tipo=#Form.Filtro_Tipo#&Filtro_Entrada=#Form.Filtro_Entrada#&Filtro_Salida=#Form.Filtro_Salida#&HFiltro_NombreBloque=#Form.Filtro_NombreBloque#&HFiltro_Tipo=#Form.Filtro_NombreBloque#&HFiltro_Entrada=#Form.Filtro_Entrada#&HFiltro_Salida=#Form.Filtro_Salida#&Filtro_Hnombre=#form.Filtro_Hnombre#&HFiltro_Hnombre=#form.HFiltro_Hnombre#">
<cfelse>
	<cflocation url="HorarioTipo.cfm?Pagina2=#pagina2#&Pagina=#pagina#&Filtro_NombreBloque=#Form.Filtro_NombreBloque#&Filtro_Tipo=#Form.Filtro_Tipo#&Filtro_Entrada=#Form.Filtro_Entrada#&Filtro_Salida=#Form.Filtro_Salida#&HFiltro_NombreBloque=#Form.Filtro_NombreBloque#&HFiltro_Tipo=#Form.Filtro_NombreBloque#&HFiltro_Entrada=#Form.Filtro_Entrada#&HFiltro_Salida=#Form.Filtro_Salida#&Filtro_Hnombre=#form.Filtro_Hnombre#&HFiltro_Hnombre=#form.HFiltro_Hnombre#&#params#">
</cfif>

