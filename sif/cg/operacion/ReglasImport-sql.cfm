<cfsetting requesttimeout="3600">

<cfif isdefined("Form.ModificarLote")>
	<cfquery name="updLote" datasource="#Session.DSN#">
		update PCReglasEImportacion set
			PCREIdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCREIdescripcion#">,
			PCREIfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.PCREIfecha)#">, 
			Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
	</cfquery>
	
<cfelseif isdefined("Form.EliminarLote")>

	<cftransaction>
		<cfquery name="delLote" datasource="#Session.DSN#">
			delete from PCReglasDImportacion
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
		</cfquery>
		
		<cfquery name="delLote" datasource="#Session.DSN#">
			delete from PCReglasEImportacion
			where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
		</cfquery>
	</cftransaction>

<cfelseif isdefined("Form.ValidarReglas")>

	<cftry>
		<cfinvoke component="sif.Componentes.CG_AplicaImportacionReglas" method="validacionRegistros" returnvariable="isOk">
			<cfinvokeargument name="PCREIid" value="#Form.PCREIid#"/>
		</cfinvoke>
	<cfcatch type="any">
		<cf_errorCode	code = "50242" msg = "Error en Procedimiento de Validacion de Reglas">
	</cfcatch>
	</cftry>

<cfelseif isdefined("Form.Aplicar")>

		<cfinvoke component="sif.Componentes.CG_AplicaImportacionReglas" method="CG_AplicaImportacionReglas" returnvariable="isOk">
			<cfinvokeargument name="PCREIid" value="#Form.PCREIid#"/>
		</cfinvoke>
       <cfif NOT isOk>
       		<cfthrow message="No se pudo realizar la Aplicacion, verifique los errores de las Reglas">
       </cfif>

<cfelseif isdefined("Form.Alta")>
	<cfquery name="insRegla" datasource="#Session.DSN#">
		insert into PCReglasDImportacion (PCREIid, PCRid, Ecodigo, Cmayor, Cmascara, PCEMid, Ocodigo, Oformato, PCRref, PCRrefsys, PCRdescripcion, PCRregla, PCRvalida, PCRdesde, PCRhasta, Usucodigo, Ulocalizacion, PCRaplicada, PCRGcodigo, BMUsucodigo)
		select 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Right('0000'&Trim(Form.Cmayor), 4)#">,
			b.CPVformatoF,
			b.PCEMid,
			null,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oformato#">,
			<cfif Len(Trim(Form.PCRref)) and Len(Trim(Form.PCRrefsys)) EQ 0>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRref#">,
			<cfelse>
				null,
			</cfif>
			<cfif Len(Trim(Form.PCRrefsys))>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRrefsys#">,
			<cfelse>
				null, 
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRdescripcion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CtaFinal#">,
			<cfif isdefined("Form.PCRvalida")>
				'S',
			<cfelse>
				'N',
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.PCRdesde)#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.PCRhasta)#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			'00',
			0,
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRGcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		from CtasMayor a
			left outer join CPVigencia b
				on <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between b.CPVdesde and b.CPVhasta
				and b.Cmayor = a.Cmayor
				and b.Ecodigo = a.Ecodigo
				and b.PCEMid = a.PCEMid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Right('0000'&Trim(Form.Cmayor), 4)#">
	</cfquery>
<cfelseif isdefined("Form.Cambio")>
	<cfquery name="updRegla" datasource="#Session.DSN#">
		update PCReglasDImportacion set
			Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Right('0000'&Trim(Form.Cmayor), 4)#">,
			PCEMid = (
                                select min(b.PCEMid)
                                from CtasMayor b
                                where b.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Right('0000'&Trim(Form.Cmayor), 4)#">
                                and b.Ecodigo = #Session.Ecodigo#
			),
			Ocodigo = null,
			Oformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oformato#">,
			<cfif Len(Trim(Form.PCRref)) and Len(Trim(Form.PCRrefsys)) EQ 0>
				PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRref#">,
			<cfelse>
				PCRref = null,
			</cfif>
			<cfif Len(Trim(Form.PCRrefsys))>
				PCRrefsys = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRrefsys#">,
			<cfelse>
				PCRrefsys = null,
			</cfif>
			PCRdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRdescripcion#">,
			PCRregla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CtaFinal#">,
			<cfif isdefined("Form.PCRvalida")>
				PCRvalida = 'S',
			<cfelse>
				PCRvalida = 'N',
			</cfif>
			PCRdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.PCRdesde)#">,
			PCRhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.PCRhasta)#">,
			Usucodigo = #Session.Usucodigo#,
            PCRGcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PCRGcodigo#">,
			BMUsucodigo = #Session.Usucodigo#
		where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
		and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
	</cfquery>
	
	<cfquery name="updMascaras" datasource="#Session.DSN#">
		update PCReglasDImportacion set
			Cmascara = (
				select min(b.CPVformatoF)
				from CPVigencia b
				where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between b.CPVdesde and b.CPVhasta
				and b.Cmayor = PCReglasDImportacion.Cmayor
				and b.Ecodigo = PCReglasDImportacion.Ecodigo
				and b.PCEMid = PCReglasDImportacion.PCEMid
			)
		where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
		and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
	</cfquery>

<cfelseif isdefined("Form.Baja")>

	<cfquery name="delRegla" datasource="#Session.DSN#">
		delete from PCReglasDImportacion
		where PCREIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCREIid#">
		and PCRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRid#">
	</cfquery>

</cfif>

<cfset params = "">
<cfif not (isdefined("Form.Aplicar") and isOK) and not isdefined("Form.EliminarLote")>
	<cfif isdefined("Form.PCREIid") and not isdefined("Form.EliminarLote")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "PCREIid=" & Form.PCREIid>
	</cfif>
	<cfif isdefined("Form.PCRid") and not isdefined("Form.Baja") and not isdefined("Form.Alta")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "PCRid=" & Form.PCRid>
	</cfif>
	<cfif isdefined("Form.PageNum")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum>
	</cfif>
	<cfif isdefined("Form.filtro_PCRid")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRid=" & Form.filtro_PCRid>
	</cfif>
	<cfif isdefined("Form.filtro_Cmayor")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Cmayor=" & Form.filtro_Cmayor>
	</cfif>
	<cfif isdefined("Form.filtro_Oformato")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Oformato=" & Form.filtro_Oformato>
	</cfif>
	<cfif isdefined("Form.filtro_PCRregla")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRregla=" & Form.filtro_PCRregla>
	</cfif>
	<cfif isdefined("Form.filtro_PCRvalida")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRvalida=" & Form.filtro_PCRvalida>
	</cfif>
	<cfif isdefined("Form.filtro_PCRdesde")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRdesde=" & Form.filtro_PCRdesde>
	</cfif>
	<cfif isdefined("Form.filtro_PCRhasta")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_PCRhasta=" & Form.filtro_PCRhasta>
	</cfif>
	<cfif isdefined("Form.filtro_ErrVal")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_ErrVal=" & Form.filtro_ErrVal>
	</cfif>
    <cfif isdefined("Form.PCRGcodigo")>
		<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "PCRGcodigo=" & Form.PCRGcodigo>
	</cfif>
</cfif>
<cflocation url="ReglasImport.cfm#params#">


