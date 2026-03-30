<!--- Faltan validaciones de indices alternos --->

<cfscript>
function Ajustar(valor,longitud){
	if (Len(valor) ge longitud) return valor;
	return RepeatString('0', longitud-len(valor))&valor;
}
</cfscript>

<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsCuentaMayor" datasource="#Session.DSN#">
			select PCEMid
			from CtasMayor
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
		</cfquery>
		<cfif rsCuentaMayor.recordCount EQ 0>
			<cf_errorCode	code = "50562" msg = "No existe cuenta mayor">
		<cfelseif Len(Trim(rsCuentaMayor.PCEMid)) EQ 0>
			<cf_errorCode	code = "50563" msg = "La cuenta mayor no tiene plan de cuentas.">
		</cfif>

		<cfquery name="rsPCNidProyRec" datasource="#Session.DSN#">
			select m1.PCNid as PCNidProy, m2.PCNid as PCNidRec
			from PRJparametros p, PCNivelMascara m1, PCNivelMascara m2
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and m1.PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaMayor.PCEMid#">
			and m2.PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaMayor.PCEMid#">
			and p.PCEcatidProyecto = m1.PCEcatid
			and p.PCEcatidRecurso = m2.PCEcatid
		</cfquery>
		<cfif rsPCNidProyRec.recordCount EQ 0>
			<cf_errorCode	code = "50564" msg = "La cuenta de mayor no está asociada a un plan de cuentas para administración de proyectos.">
		</cfif>

		<cfquery name="rsPCNidActividad" datasource="#Session.DSN#">
			select m2.PCNid, m2.PCNlongitud
			from PCNivelMascara m1, PCNivelMascara m2, PRJparametros p
			where m1.PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaMayor.PCEMid#">
			and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and m1.PCEcatid = p.PCEcatidProyecto
			and m1.PCEMid = m2.PCEMid
			and m1.PCNid = m2.PCNdep
		</cfquery>
		<cfif rsPCNidActividad.recordCount EQ 0>
			<cf_errorCode	code = "50564" msg = "La cuenta de mayor no está asociada a un plan de cuentas para administración de proyectos.">
		<cfelseif rsPCNidActividad.PCNlongitud LT Len(Trim(Form.PRJcodigo))>
			<cf_errorCode	code = "50565"
							msg  = "El código del proyecto no puede ser mayor a @errorDat_1@"
							errorDat_1="#rsPCNidActividad.PCNlongitud#"
			>
		</cfif>

		<cftransaction>
			<cfquery name="rsCatalogoActividad" datasource="#Session.DSN#">
				insert into PCECatalogo(CEcodigo, PCEcodigo, PCEdescripcion, PCElongitud, PCEempresa, PCEref, PCEactivo, Usucodigo, Ulocalizacion)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="A#Ajustar(Trim(Form.PRJcodigo), rsPCNidActividad.PCNlongitud)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="Actividades de #Form.PRJdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPCNidActividad.PCNlongitud#">, 
					1,
					1,
					1,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					'00'
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsCatalogoActividad">

			<cfquery name="rsDetCatalogoActividad" datasource="#Session.DSN#">
				insert into PCDCatalogo(PCEcatid, PCEcatidref, Ecodigo, PCDactivo, PCDvalor, PCDdescripcion, Usucodigo, Ulocalizacion)
				select
					PCEcatidProyecto, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCatalogoActividad.identity#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ajustar(Trim(Form.PRJcodigo), rsPCNidActividad.PCNlongitud)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					'00'
				from PRJparametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		
			<cfquery name="ABC_Proyectos" datasource="#Session.DSN#">
				insert into PRJproyecto (Ecodigo, PRJTid, PRJcodigo, PRJdescripcion, Cmayor, PCEMid, PCNidProyecto, PCNidRecurso, PCNidActividad, PCEcatidActividad, SNcodigo, PRJfechaInicio, Mcodigo, PRJestado)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJTid#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJcodigo)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaMayor.PCEMid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPCNidProyRec.PCNidProy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPCNidProyRec.PCNidRec#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPCNidActividad.PCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCatalogoActividad.identity#">,
					<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
					<cfelse>
						null, 
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.PRJfechaInicio)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.PRJestado#">
				)
			</cfquery>
			<cfset modo="ALTA">
		
		</cftransaction>

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_Proyectos" datasource="#Session.DSN#">
			if not exists(
				select 1
				from PRJActividad
				where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJid#">
			)
			delete PRJproyecto 
			where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJid#">
		</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="rsPCNidActividad" datasource="#Session.DSN#">
			select m1.PCNlongitud
			from PRJproyecto a, PCNivelMascara m1
			where a.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJid#">
			and a.PCEMid = m1.PCEMid
			and a.PCNidActividad = m1.PCNid
		</cfquery>
		<cfif rsPCNidActividad.PCNlongitud LT Len(Trim(Form.PRJcodigo))>
			<cf_errorCode	code = "50565"
							msg  = "El código del proyecto no puede ser mayor a @errorDat_1@"
							errorDat_1="#rsPCNidActividad.PCNlongitud#"
			>
		</cfif>

		<cftransaction>
			<cfquery name="rsCatalogoActividad" datasource="#Session.DSN#">
				update PCECatalogo
				   set PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="A#Ajustar(Trim(Form.PRJcodigo), rsPCNidActividad.PCNlongitud)#">,
				   	   PCEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="Actividades de #Form.PRJdescripcion#">
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="A#Trim(Form.PRJcodigo_ant)#">
			</cfquery>
			
			<cfquery name="rsp1" datasource="#Session.DSN#">
				select PCEcatidProyecto
				from PRJparametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfquery name="rsDetCatalogoActividad" datasource="#Session.DSN#">
				update PCDCatalogo
				   set PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ajustar(Trim(Form.PRJcodigo), rsPCNidActividad.PCNlongitud)#">,
				   	   PCDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJdescripcion#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsp1.PCEcatidProyecto#">
				and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJcodigo_ant)#">
			</cfquery>

			<cfquery name="ABC_Proyectos" datasource="#Session.DSN#">
				update PRJproyecto set 
					PRJTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJTid#">, 
					PRJcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJcodigo)#">, 
					PRJdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJdescripcion#">, 
					<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo))>
						SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
					<cfelse>
						SNcodigo = null, 
					</cfif>
					PRJfechaInicio = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.PRJfechaInicio)#">,
					PRJestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.PRJestado#">
				where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJid#">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)				
			</cfquery>
		</cftransaction>
		<cfset modo="ALTA">  				  
	</cfif>
	
</cfif>

<cfoutput>
<form action="Proyectos.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="PRJid" type="hidden" value="#PRJid#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


