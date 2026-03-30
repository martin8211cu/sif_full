<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfinvoke key="MSG_YaEstaAplicadaLaMarca" default="Ya está Aplicada la marca"	 returnvariable="MSG_YaEstaAplicadaLaMarca" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_HayMarcasDuplicadas" default="Hay Marcas duplicadas. Favor verifique"	 returnvariable="MSG_HayMarcasDuplicadas" component="sif.Componentes.Translate" method="Translate"/>
<cfsetting requesttimeout="3600">
<!---======= ELiminar marcas ========---->
<cfif isdefined("form.BOTON") and form.BOTON EQ 'Eliminar'>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<!----Actualiza la tabla de marcas (RHControlMarcas) poner nulo el NumeroLote(es el CAMid de RHCMCalculoAcumMarcas)--->
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas set numlote = null, grupomarcas = null, registroaut = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ( numlote in (#form.chk#)
						or
					  numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="-1"><!---para poner como no procesadas las marcas que no debería porque el empleado no marca---->
					)
		</cfquery>
		<!---Eliminar registro ---->
		<cfquery datasource="#session.DSN#">
			delete RHCMCalculoAcumMarcas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAMid in (#form.chk#)
		</cfquery>		
	</cfif>
<!---======== Aplicar marcas masivamente =========----->
<cfelseif isdefined("form.btnProcesar_Masivo")>
	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.CAMid,a.CAMfdesde,
			case when (	select count(1) 
						from RHCMCalculoAcumMarcas x 
						where x.DEid = a.DEid
						  and x.CAMfdesde = a.CAMfdesde
						  and x.CAMid <> a.CAMid
						  and x.CAMpermiso <> a.CAMpermiso
						  and x.CAMgeneradoporferiado = 0
						  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado) > 0 then CAMid
				else 0 end as inconsistencia,
			case when (	select count(1) 
			from RHCMCalculoAcumMarcas x 
			inner join RHHControlMarcas z
				on x.DEid = z.DEid
				and x.CAMfdesde = z.fechahoramarca
			where x.DEid = a.DEid
			  and x.CAMfdesde = a.CAMfdesde
			  and x.CAMid <> a.CAMid
			  and x.CAMpermiso = a.CAMpermiso
			  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado) > 0 then CAMid
			else 0 end marcaIgual
		from RHCMCalculoAcumMarcas a
			inner join DatosEmpleado b
				on a.DEid = b.DEid
				and a.Ecodigo = b.Ecodigo
			left outer join RHJornadas c
				on a.RHJid = c.RHJid
				and a.Ecodigo = c.Ecodigo
			<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
				inner join RHCMEmpleadosGrupo d
					on a.DEid = d.DEid
					and a.Ecodigo = d.Ecodigo															
					and d.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">
			</cfif>
			
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.CAMestado = 'P'
			<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
				and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			</cfif>
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
			<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) 
					and isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
				<cfif form.fechaInicio GT form.fechaFinal>
					and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
				<cfelseif form.fechaFinal GT form.fechaInicio>
					and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#">
				<cfelse>
					and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
				</cfif>
			<cfelseif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) and (not isdefined("form.fechaFinal") or  len(trim(form.fechaFinal)) EQ 0)>
				and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
			<cfelseif isdefined("form.fechaFinal") and len(trim(form.fechaFinal)) and (not isdefined("form.fechaInicio") or  len(trim(form.fechaInicio)) EQ 0)>
				and <cf_dbfunction name="to_datechar" args="a.CAMfhasta"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#">
			</cfif>	
		order by {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)}, a.CAMfdesde, a.CAMfhasta
	</cfquery>
	<cfif rsLista.recordcount gt 0>
		<cfloop query="rsLista">
			<cfif rsLista.inconsistencia EQ 0 and rsLista.marcaIgual EQ 0>
				<cfinvoke component="rh.Componentes.RH_ProcesoAplicaMarcas" method="RH_ProcesoAplicaMarcas" 
					camid="#rsLista.CAMid#">
			</cfif>
		</cfloop>
	</cfif>
<!---======== Aplicar marcas =========----->
<cfelseif isdefined("form.BOTON") and form.BOTON EQ 'Aplicar'>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfloop list="#form.chk#" index="i">			
			<!--- VERIFICA SI LA MARCA YA HA SIDO PROCESADA --->
			<cfquery name="VerificaMarcas" datasource="#session.DSN#">
				select a.CAMfdesde
				from RHCMCalculoAcumMarcas a
				inner join RHHControlMarcas b
					on b.DEid = a.DEid 
					and b.fechahoramarca = a.CAMfdesde
				where a.CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<cfif VerificaMarcas.RecordCount>	
				<cf_throw message="#MSG_YaEstaAplicadaLaMarca#&nbsp;#LSDateFormat(VerificaMarcas.CAMfdesde,'dd/mm/yyyy h:mm:ss')#" errorcode="4025">
			<cfelse>
				<cfinvoke component="rh.Componentes.RH_ProcesoAplicaMarcas" method="RH_ProcesoAplicaMarcas" camid="#i#">
			</cfif>
		</cfloop>
	</cfif>
<!---======== Genera marcas para los dias feriados =========----->
<cfelseif isdefined("btnGenerar")>
	<cfparam name="Form.RHFid" type="numeric">
	<cfinvoke component="rh.Componentes.RH_ProcesoGeneraMarcas" method="RH_ProcesoGeneraFeriados"
		rhfid = "#Form.RHFid#">
<!---======== Genera marcas para los dias de permiso =========----->
<cfelseif isdefined("btnGenerarPermisos")>
	<cfinvoke component="rh.Componentes.RH_ProcesoGeneraMarcas" method="RH_ProcesoGeneraPermisos">
</cfif>
<cfoutput>
	<form name="form1" action="ProcesaMarcas-Lista.cfm" method="post">		
		<input type="hidden" name="btnFiltrar" value="btnFiltrar">	
		<cfif isdefined("form.chk") and len(trim(form.chk)) gt 0>
		<input type="hidden" name="chk" value="#form.chk#">	
		</cfif>
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		<input type="hidden" name="DEid" value="#form.DEid#">		
		</cfif>
		<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
		<input type="hidden" name="Grupo" value="#form.Grupo#">
		</cfif>
		<cfif isdefined("form.ver") and len(trim(form.ver))>
		<input type="hidden" name="ver" value="#form.ver#">
		</cfif>
		<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
		<input type="hidden" name="fechaInicio" value="#form.fechaInicio#">
		</cfif>
		<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
		<input type="hidden" name="fechaFinal" value="#form.fechaFinal#">
		</cfif>
		<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
		<input type="hidden" name="RHJid" value="#form.RHJid#">	
		</cfif>
	</form>
</cfoutput>
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>

