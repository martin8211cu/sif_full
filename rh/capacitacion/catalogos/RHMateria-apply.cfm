<cfset form.Mdescripcion = Trim(StripCR(form.Mdescripcion))>
<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHMateria"
				redirect="RHMateria.cfm"
				timestamp="#form.ts_rversion#"
				field1="Mcodigo"
				type1="numeric"
				value1="#form.Mcodigo#"
		>
	<cfquery datasource="#session.dsn#">
		update RHMateria
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		, Mnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Mnombre#" null="#Len(form.Mnombre) Is 0#">
		, Mdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Mdescripcion#" null="#Len(form.Mdescripcion) Is 0#">
		, Msiglas = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Msiglas#" null="#Len(form.Msiglas) Is 0#">
		, Mactivo =  <cfif isdefined('form.Mactivo')>1<cfelse>0</cfif>
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		, RHACid = <cfif isdefined('form.RHACid') and form.RHACid NEQ '' and form.RHACid NEQ '-1'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACid#"><cfelse>null</cfif>
		
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
    <cfset modo = 'CAMBIO'>
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHMateriasGrupo
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from RHOfertaAcademica
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from RHMateria
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">
	</cfquery>
	<cfset modo = 'ALTA'>
<cfelseif IsDefined("form.Nuevo")>
	<cfset modo = 'ALTA'>
<cfelseif IsDefined("form.Alta")>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into RHMateria (
				Ecodigo,
				CEcodigo,
				Mnombre,Mdescripcion,
				Msiglas,
				Mactivo,
				BMfecha,
				BMUsucodigo,
				RHACid)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Mnombre#" null="#Len(form.Mnombre) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Mdescripcion#" null="#Len(form.Mdescripcion) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Msiglas#" null="#Len(form.Msiglas) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.Mactivo')#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfif isdefined('form.RHACid') and form.RHACid NEQ '' and form.RHACid NEQ '-1'>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACid#">
				<cfelse>null</cfif>			
				)
		  <cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="rsInsert" returnvariable="LvarMat">

		<cfquery name="rsV" datasource="#session.dsn#"> --- fcastro20110909  no necesita consultar el valor, se puede utilizar  cf_dbidentity1 
				select RHIAid 
				from RHInstitucionesA 
				where Ecodigo=#session.Ecodigo#
				and RHIAcodigo='999'
		</cfquery>
		<cfif rsV.Recordcount eq 0>
				<cfquery datasource="#session.dsn#"  name="rsInsert2" >
				insert into RHInstitucionesA (Ecodigo,RHIAcodigo,RHIAnombre,BMfecha,BMUsucodigo,CEcodigo)
				values(#session.Ecodigo#,
						'999',
						'Institución Genérica',
						#now()#,
						#session.Usucodigo#
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">)
				 <cf_dbidentity1 datasource="#session.dsn#"><!--- fcastro20110909 para la insercion de la Institucion--->
			</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="rsInsert2" returnvariable="LvarInstitucion">
		<cfelse>
			<cfset LvarInstitucion=rsV.RHIAid>
		</cfif>
		<cfquery datasource="#session.dsn#"><!--- fcastro20110909 'LvarInstitucion' trae el id  Institucion--->
			insert into RHOfertaAcademica (RHIAid, Mcodigo, RHOAactivar, Ecodigo, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarInstitucion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMat#">,
				1, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			 
		</cfquery>
		
		
		<cfif isdefined('form.ckMatGr') and isdefined('rsInsert')>
			<cfset listaGrupos = ListToArray(form.ckMatGr,",")>
			<cfset j = ArrayLen(listaGrupos)>
	
			<cfloop index = "k" from = "1" to = #j#>			
				<cfquery datasource="#session.dsn#">
					insert RHMateriasGrupo 
						(Mcodigo, RHGMid, Ecodigo, BMfecha, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#listaGrupos[k]#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)					
						
				</cfquery>
			</cfloop>	
		</cfif>	
	</cftransaction>
    <cfset modo = 'CAMBIO'>
<cfelseif isdefined('form.bandBorrar') and form.bandBorrar EQ 1>
	<!--- Borrado de los grupos de cursos para el curso seleccionado --->
	
	<cfif isdefined('form.RHGMid')>
		<cfquery datasource="#Session.DSN#">
			delete from RHMateriasGrupo
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and RHGMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" >
				and Mcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" >
		</cfquery>
	</cfif>
	
	<cfset modo="CAMBIO">	
<cfelseif isdefined('form.bandBorrar') and form.bandBorrar EQ 2>
	<!--- Insercion del curso para el grupo --->
	<cfif isdefined('form.Mcodigo')>
		<cfquery datasource="#Session.DSN#">
			insert RHMateriasGrupo 
				(Mcodigo, RHGMid, Ecodigo, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" >,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
		</cfquery>
	</cfif>
	
	<cfset modo="CAMBIO">	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<cfparam name="params" default="">
<cfset params = params & 'modo=' & modo>
<cfif isdefined('form.Cambio') and isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) or (isdefined('form.bandBorrar') and (form.bandBorrar EQ 1 or form.bandBorrar EQ 2))>
    <cfset params = params & '&Mcodigo=' & form.Mcodigo>
</cfif>

<cfif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
	<cfset params = params & '&PageNum=' & form.PageNum>
</cfif>
<cflocation url="RHMateria.cfm?#params#">
